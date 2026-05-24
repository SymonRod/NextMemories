# Feature: Sync (Cache Offline)

## Obiettivo

Permettere all'utente di selezionare contenuti da tenere disponibili offline (album e/o range temporale). I file vengono scaricati nella cache privata dell'app e non sono visibili nella galleria di sistema.

---

## Scope

### Cosa si può sincronizzare
- **Album** — l'utente seleziona uno o più album da tenere offline
- **Time range** — l'utente seleziona un intervallo temporale (es. "ultimi 30 giorni", "ultimo anno")

### Cosa non è in scope (questa versione)
- Sync per cartella Nextcloud (richiederebbe PROPFIND WebDAV separato)
- Export nella galleria Android (è la feature MediaStore, separata)
- Sync bidirezionale / upload

---

## Architettura

Segue FFCA. La feature vive in `lib/features/sync/`.

```
features/sync/
├── data/
│   ├── datasources/
│   │   ├── sync_local_datasource.dart      # lettura/scrittura Drift
│   │   └── sync_download_datasource.dart   # download file via WebDAV/preview
│   ├── models/
│   │   └── sync_rule_model.dart            # Freezed + Drift table companion
│   └── repositories/
│       └── sync_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── sync_rule.dart                  # Freezed entity
│   │   └── sync_status.dart               # enum: idle, running, paused, error
│   ├── repositories/
│   │   └── i_sync_repository.dart
│   └── usecases/
│       ├── get_sync_rules_use_case.dart
│       ├── save_sync_rule_use_case.dart
│       ├── delete_sync_rule_use_case.dart
│       └── run_sync_use_case.dart          # orchestrazione download
└── presentation/
    ├── providers/
    │   ├── sync_rules_provider.dart        # syncRepositoryProvider + syncRulesProvider
    │   └── sync_progress_provider.dart     # syncProgressNotifierProvider
    └── screens/
        ├── sync_settings_screen.dart       # gestione regole
        └── sync_progress_screen.dart       # avanzamento download
```

---

## Persistenza (Drift)

### Tabella `sync_rules`

| Colonna | Tipo | Descrizione |
|---|---|---|
| `id` | int PK | auto-increment |
| `type` | text | `'album'` oppure `'time_range'` |
| `cluster_id` | text? | identificatore album, formato `user/album_name` (es. `user/My Album`) — è il valore usato per richiedere le foto dell'album, non l'`album_id` int |
| `album_name` | text? | nome leggibile |
| `days_back` | int? | per time_range: quanti giorni indietro (es. 30, 365) |
| `download_full` | bool | true = scarica originale WebDAV, false = solo preview alta risoluzione |
| `last_synced_at` | DateTime? | timestamp ultimo sync completato |
| `created_at` | DateTime | timestamp creazione regola |

### Tabella `sync_cache_entries`

Tiene traccia dei file già scaricati per evitare re-download inutili.

| Colonna | Tipo | Descrizione |
|---|---|---|
| `file_id` | int | fileId Nextcloud (parte della PK composta) |
| `rule_id` | int | regola che ha causato il download (parte della PK composta, FK verso `sync_rules`) |
| `download_full` | bool | qualità scaricata: originale WebDAV vs preview (parte della PK composta) |
| `local_path` | text | path assoluto sul filesystem dell'app |
| `etag` | text | per validare se il file è cambiato |
| `downloaded_at` | DateTime | timestamp download |
| `size_bytes` | int | per mostrare spazio occupato |

**PK composta `(file_id, rule_id, download_full)`**: una stessa foto può rientrare in più regole (es. è in un album *e* nel time range degli ultimi 30 giorni), quindi vengono registrate più righe — una per regola. `download_full` fa parte della PK perché due regole sulla stessa foto a qualità diversa (originale vs preview) producono **file fisici distinti** sul disco: la dedup e il reference counting alla cancellazione ragionano quindi su `(file_id, download_full)`, non sul solo `file_id` (vedi `DeleteSyncRuleUseCase`).

---

## Entity di dominio

### `SyncRule`
```dart
@freezed
class SyncRule with _$SyncRule {
  const factory SyncRule({
    required int id,
    required SyncRuleType type,
    String? clusterId,
    String? albumName,
    int? daysBack,
    required bool downloadFull,
    DateTime? lastSyncedAt,
    required DateTime createdAt,
  }) = _SyncRule;
}

enum SyncRuleType { album, timeRange }
```

### `SyncStatus`
```dart
enum SyncStatus { idle, running, paused, error }

@freezed
class SyncProgress with _$SyncProgress {
  const factory SyncProgress({
    required SyncStatus status,
    required int total,
    required int downloaded,
    required int failed,
    String? currentFile,
  }) = _SyncProgress;
}
```

---

## Use Cases

### `RunSyncUseCase`
Espone il sync alla presentation delegando a `SyncRepositoryImpl.runSync()`, dove vive l'orchestrazione descritta sotto. Per ogni `SyncRule` attiva:
1. Recupera la lista foto attese dalla regola (via `ITimelineRepository` o `IAlbumsRepository`)
2. **Reconcile** — confronta le foto attese con le righe `sync_cache_entries` di quella regola:
   - foto attese ma assenti in cache → da scaricare
   - foto attese ma con `etag` diverso → da ri-scaricare (file cambiato)
   - righe in cache non più attese → da rimuovere (vedi *Pruning* sotto)
3. Scarica le foto mancanti o cambiate (download atomico, vedi sotto)
4. Esegue il pruning delle righe non più attese
5. Aggiorna `sync_cache_entries` e `sync_rules.last_synced_at`
6. Emette progresso tramite `Stream<SyncProgress>`

#### Pruning (regola scorrevole / contenuto cambiato lato server)
Il time range è relativo a *oggi*: a ogni sync il range si sposta e delle foto ne escono. Lo stesso vale per gli album, da cui si possono rimuovere foto, o per foto/album cancellati su Nextcloud (il fetch allo step 1 ritorna `404` o una lista più corta). Senza pruning la cache cresce all'infinito e resta piena di file orfani.

Per ogni riga `sync_cache_entries` della regola il cui `file_id` **non** compare più tra le foto attese:
1. Rimuovi la riga `(file_id, rule_id, download_full)`
2. Cancella il file fisico **solo se** nessun'altra regola referenzia ancora la stessa foto *alla stessa qualità* (reference counting su `(file_id, download_full)`, vedi `DeleteSyncRuleUseCase`)

#### Scaricamento
- Se `downloadFull = false`: usa `GET /image/preview/{fileId}?c={etag}&x=1920&y=1920&a=1` (preview alta risoluzione). Il parametro `c` (etag) è **obbligatorio**.
- Se `downloadFull = true`: usa WebDAV `GET /remote.php/dav/files/{username}/{path}`. Il `{path}` DAV non è presente nella risposta di `POST /days` (che ritorna solo `fileid`/`basename`): serve un passaggio intermedio `GET /image/info/{fileId}` per ottenere il campo `filename` (path DAV completo).

Il path locale dove salvare: `{appDocumentsDir}/sync/{fileId}.{ext}`, dove:
- `{appDocumentsDir}` è la directory documenti persistente dell'app (`getApplicationDocumentsDirectory()`), **non** la cache di sistema: i file offline non devono poter essere rimossi dall'OS sotto pressione di storage.
- `{ext}` è derivata dal `mimetype` (o dall'estensione del `basename`), non hardcoded a `.jpg`: possono esserci PNG, HEIC e, per gli originali, anche video.

**Download atomico** — se la rete cade a metà download resta un file corrotto che verrebbe poi servito come valido. Per evitarlo:
1. Scarica su un file temporaneo `{fileId}.{ext}.part`
2. A download completato, `rename` atomico → `{fileId}.{ext}`
3. Inserisci/aggiorna la riga in `sync_cache_entries` **solo dopo** il rename

All'avvio di un sync, eventuali `.part` residui da un'esecuzione interrotta vanno eliminati prima di iniziare.

### `GetSyncRulesUseCase`
Legge tutte le regole da Drift. `Either<Failure, List<SyncRule>>`.

### `SaveSyncRuleUseCase`
Inserisce o aggiorna una regola. Valida che non esistano duplicati (stesso `clusterId` o stesso `daysBack`).

### `DeleteSyncRuleUseCase`
Rimuove la regola e le righe `sync_cache_entries` associate a quel `rule_id`. Per ogni file, cancella il file fisico dal disco **solo se** nessun'altra regola lo referenzia ancora *alla stessa qualità*: se la coppia `(file_id, download_full)` compare ancora in righe con `rule_id` diverso, il `local_path` va mantenuto.

---

## Provider

### `syncRepositoryProvider` (`sync_rules_provider.dart`)
Provider `keepAlive` che costruisce `SyncRepositoryImpl` con le dipendenze necessarie (`SyncLocalDatasource`, `SyncDownloadDatasource`, `TimelineRepositoryImpl`, `AlbumsRepositoryImpl`). Si invalida automaticamente se la configurazione auth cambia. Dichiarato in `sync_rules_provider.dart` poiché `syncProgressNotifierProvider` dipende da esso tramite import.

### `syncRulesProvider` (`sync_rules_provider.dart`)
`AsyncNotifier<List<SyncRule>>`. Legge le regole da Drift tramite `GetSyncRulesUseCase`.

Metodi:
- `saveRule(SyncRule)` — inserisce o aggiorna una regola, poi `invalidateSelf()`
- `deleteRule(int ruleId)` — rimuove regola e file fisici orfani, poi `invalidateSelf()`

### `syncProgressNotifierProvider` (`sync_progress_provider.dart`)
`Notifier<SyncProgress>`. Stato iniziale `SyncProgress.idle()`.

Metodi:
- `startSync()` — guard su `status == running`, poi ascolta lo stream di `RunSyncUseCase` e aggiorna `state` a ogni evento. La `StreamSubscription` viene cancellata in `ref.onDispose`.
- `cancelSync()` — cancella la subscription e riporta lo stato a `idle`.

---

## UI

### `SyncSettingsScreen`
Accessibile dalle impostazioni (tab Profile o voce menu).

Contenuto:
- Lista regole configurate con stato (ultima sync, numero file, spazio occupato)
- Pulsante "Aggiungi regola" → bottom sheet con scelta tipo
  - **Album**: lista album fetchati da API, selezione multipla
  - **Time range**: slider o selezione preset (7g / 30g / 3m / 1a)
- Opzione per ogni regola: scarica preview vs originale
- Pulsante "Sincronizza ora" (avvia manualmente)
- Spazio totale occupato dalla cache sync

### `SyncProgressScreen` (o bottom sheet)
Mostrata durante il sync in corso:
- Barra di avanzamento con `downloaded / total`
- Nome file corrente
- Pulsante pausa/annulla

---

## Trigger sync

Per questa versione: **solo manuale** (pulsante "Sincronizza ora").

Versioni future:
- Sync automatico in background (WorkManager via flutter_background_fetch)
- Sync solo su Wi-Fi (connectivity_plus)

---

## Integrazione con Timeline e Album (offline)

### Livello immagini (✅ implementato)

Quando Timeline o Album caricano le foto, i provider arricchiscono ogni `Photo` con `localPath` dalla cache. I widget usano `Image.file` se `localPath != null`, altrimenti `CachedNetworkImage`.

### Livello metadati (✅ implementato)

**Problema**: `timelineDaysProvider` e `dayPhotosProvider` fanno chiamate di rete al boot. Se il dispositivo è offline, throwano prima ancora di poter usare `localPath`. Risultato: schermata di errore "Failed host lookup" anche se le foto sono in cache.

**Causa**: la cache attuale (`sync_cache_entries`) salva solo i file scaricati, non i metadati necessari a ricostruire la lista (`basename`, `epoch`, `dayId`, `mimetype`, ecc.).

**Soluzione pianificata — `PhotoMetadataCache` via Hive**:

Hive è già inizializzato in `main.dart`. Si aggiunge un layer di cache opportunistica:

1. **`lib/core/cache/photo_metadata_cache.dart`** — classe con box Hive `photo_metadata_cache` che espone:
   - `saveDays(List<PhotoDay>)` / `getDays() → List<PhotoDay>?`
   - `savePhotosForDay(int dayId, List<Photo>)` / `getPhotosForDay(int dayId) → List<Photo>?`
   - `savePhotosForAlbum(String clusterId, List<Photo>)` / `getPhotosForAlbum(String clusterId) → List<Photo>?`
   - Serializzazione manuale con `Map<String, dynamic>` (non serve TypeAdapter)

2. **`timelineDaysProvider`** — dopo fetch riuscito salva in cache; se il fetch fallisce legge dalla cache Hive (se disponibile) altrimenti rilancia l'eccezione.

3. **`dayPhotosProvider`** — stesso pattern: salva su successo, legge dalla cache su errore. L'arricchimento `localPath` (già presente) si applica sia al path di rete sia a quello di cache.

4. **`albumPhotosProvider`** — stesso pattern con chiave `clusterId`.

**Flusso risultante**:
```
Online:  fetch rete → salva Hive → arricchisci localPath → mostra
Offline: fetch rete fallisce → leggi Hive → arricchisci localPath → mostra con File/rete
Offline senza cache Hive: throw → schermata errore (comportamento attuale)
```

**Note implementative**:
- La cache Hive non ha TTL: mostra sempre l'ultimo stato noto (coerente con un'app foto).
- Non serve invalidare la cache Hive manualmente: viene sovrascritta a ogni fetch riuscito.
- `Photo.localPath` non va serializzato nella cache Hive (è un arricchimento a runtime).
- Il box va aperto lazy con `Hive.openBox` al primo accesso, non in `main.dart`.
- Aprire il box una sola volta per istanza di `PhotoMetadataCache` (lazy init con `late final`).

---

## Ordine di implementazione

1. ✅ **Schema Drift** — tabelle `sync_rules` e `sync_cache_entries` (`lib/core/database/app_database.dart`)
2. ✅ **Domain layer** — entity, repository interface, use case
3. ✅ **Data layer** — datasource locale (Drift) + datasource download, `SyncRepositoryImpl`
4. ✅ **Orchestrazione sync** — reconcile + download atomico + pruning. Vive in `SyncRepositoryImpl.runSync()`; `RunSyncUseCase` si limita a delegare al repository.
5. ✅ **Provider** — `syncRulesProvider` e `syncProgressNotifierProvider`
6. ✅ **`SyncSettingsScreen`** — UI gestione regole
7. ⬜ **`SyncProgressScreen`** — UI avanzamento
8. ✅ **Integrazione offline** — livello immagini + livello metadati (cache Hive opportunistica per days/photos/albumPhotos)

> Test backend (step 1–4) in `test/features/sync/`: mapper, reference counting su `(file_id, download_full)`, pulizia `.part` residui.

---

## Punti aperti / robustezza (da affrontare)

Non progettati in questa versione, elencati qui per non perderli di vista:

- **Foreground service Android per sync lunghi** — scaricare un time range ampio (es. "ultimo anno") può richiedere molto tempo e banda. Senza un foreground service con notifica, Android sospende/uccide l'app quando va in background e il sync si interrompe. Impatta l'architettura di `RunSyncUseCase`, che deve poter girare fuori dal lifecycle della UI.
- **Lock anti-concorrenza** — garantire un solo sync attivo alla volta: se l'utente preme "Sincronizza ora" mentre lo stato è già `running`, l'avvio va ignorato/accodato. Lo `SyncStatus.running` esiste ma manca il meccanismo di mutua esclusione.
- **Limite di spazio + "svuota cache sync"** — tetto massimo configurabile con politica di eviction, e azione per svuotare tutta la cache sync. Oggi è tracciato solo `size_bytes`, senza alcuna strategia di limite.
- **Retry/backoff sui fallimenti** — definire numero di retry, backoff e cosa fare con file che falliscono sistematicamente (logga e salta vs blocca il sync). `SyncProgress.failed` conta gli errori ma non c'è policy.
- **Migrazione schema Drift** — l'aggiunta di `sync_rules` e `sync_cache_entries` richiede il bump di `schemaVersion` e una migration nel `MigrationStrategy` (vedi step 1 dell'ordine di implementazione).
- **Test** (`test/features/sync/`) — casi non banali da coprire: pruning del range scorrevole, reference counting alla cancellazione, ripresa dopo download interrotto (`.part` residui).

---

## Dipendenze aggiuntive

Già presenti come dipendenze dirette in pubspec.yaml:
- `drift` — persistenza regole e cache index
- `webdav_client` — download originali
- `dio` — download preview

Da aggiungere a pubspec.yaml:
- `path_provider` — per `getApplicationDocumentsDirectory()`. Attualmente è solo una dipendenza **transitiva** (presente in `pubspec.lock`, tirata da flutter_cache_manager/drift): per usarla direttamente va dichiarata come dipendenza esplicita.
