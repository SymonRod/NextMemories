# Piano di ottimizzazione — Sync & Timeline (dettagliato)

Stato: **implementato T1–T5 e S6–S8** · Restano opzionali **S9** e **S10** · Approccio:
**aggressivo** (nuovi endpoint: `/days` con `detail` inline, `/api/stream/{id}` per gli
originali, `/api/image/multipreview` per i batch di anteprime).

### Stato implementazione (verificato sul diff)
| Item | Stato | Note |
|------|-------|------|
| T1 datasource/Dio condiviso | ✅ | `timelineRepositoryProvider` (keepAlive); riusato da `timelineDays`/`dayPhotos` |
| T2 N+1 di rete | ✅ | `getPhotosByDay()` = 1 `GET /days` + max 1 `POST /days` batch; `timelinePhotosByDayProvider` |
| T3 batch local-path | ✅ | `getLocalPaths(Set<int>)` su datasource/repo/interface |
| T4 keepAlive | ✅ | `timelineDays` e `timelinePhotosByDay` `@Riverpod(keepAlive: true)` |
| T5 thumbnail+header | ✅ | preview 512→256, `memCacheWidth/Height`, header calcolati in `_TimelineList` |
| S6 download paralleli | ✅ | worker pool (5) + `StreamController` per il progress |
| S7 `/api/stream` originali | ✅ | un solo `_dio.download(MemoriesApi.stream(...))`, WebDAV rimosso |
| S8 batch expected photos | ✅ | `getDaysPhotos(List<int>)` in un batch |
| S9 multipreview | ⬜ | opzionale, non implementato |
| S10 batch pruning/countRefs | ⬜ | opzionale, `countRefs` ancora per-entry |
| Cache-first timeline | ✅ | `timelineProvider` stale-while-revalidate; 1 sola `GET /days` via `getTimeline()` |
| T6 windowed + jump-to-date | ⬜ | **backlog** — caricamento monolitico: data lontana attende tutto il pregresso |

Obiettivo: ridurre i round-trip HTTP e le query DB (da O(numero giorni/foto) a O(1) o
O(batch)) e parallelizzare i download di sync.

> Nota build: ogni modifica ai `@freezed`/`@riverpod`/model richiede
> `flutter pub run build_runner build --delete-conflicting-outputs`.
> Mai editare i file `*.g.dart` / `*.freezed.dart` a mano.

---

## Stato attuale (riferimenti)

| Area | File | Problema |
|------|------|----------|
| Timeline | `timeline_provider.dart:18` `timelineDays` | `fromConfig` ricrea Dio; niente keepAlive |
| Timeline | `timeline_provider.dart:36` `dayPhotos` | 1 `POST /days` per giorno (N+1) |
| Timeline | `timeline_provider.dart:56` `_enrichWithLocalPaths` | 1 query DB per foto (N+1) |
| Timeline | `timeline_screen.dart:75` `_DaySection` | watcha un provider per sezione → N richieste |
| Timeline | `timeline_screen.dart:152` `_PhotoTile` | preview 512px, credenziali base64 per build |
| Sync | `sync_repository_impl.dart:124` `runSync` | download seriali |
| Sync | `sync_repository_impl.dart:241` `_getExpectedPhotos` | N+1 su `getDayPhotos` |
| Sync | `sync_download_datasource.dart:94` `downloadOriginal` | `GET /image/info` + WebDAV per file |

Già pronto: `PhotoDayModel.detail` (`photo_day_model.dart:14`) esiste già → il parsing
inline è metà fatto.

---

## TIMELINE

### T1 — Datasource/Dio condiviso con keepAlive
**Perché**: oggi `timelineDays` e `dayPhotos` chiamano `TimelineRepositoryImpl.fromConfig`
a ogni run → nuovo `Dio`, nessun connection reuse (viola CLAUDE.md).

**Come**:
- Nuovo provider in `timeline_provider.dart`:
  ```dart
  @Riverpod(keepAlive: true)
  TimelineRepositoryImpl timelineRepository(Ref ref) {
    final config = ref.watch(authProvider).valueOrNull;
    if (config == null) throw Exception('Not authenticated');
    return TimelineRepositoryImpl.fromConfig(config);
  }
  ```
- `timelineDays`/`dayPhotos` usano `ref.watch(timelineRepositoryProvider)` invece di
  costruirlo. Il `Dio` è già `late final` nel datasource (`timeline_remote_datasource.dart:12`),
  quindi una sola istanza ⇒ connection reuse.

**Verifica**: log `[Timeline] GET /days` deve apparire una sola volta per refresh.

---

### T2 — Eliminare l'N+1 di rete (detail inline + fallback batch)
**Perché**: il collo di bottiglia principale. Oggi ogni sezione fa il suo `POST /days`.

**Come (aggressivo)**:
1. `MemoriesApi.days()` → variante con preload:
   ```dart
   static String days({bool noPreload = false}) =>
       '$basePath/days${noPreload ? '?nopreload=1' : ''}';
   ```
   Per la timeline NON passare `nopreload`, così la risposta include `detail`.
2. `TimelineRemoteDatasource.getDays()` ritorna i `PhotoDayModel` **con** `detail`
   popolato (già supportato dal model). Aggiungere un metodo che estrae direttamente
   `Map<int dayId, List<PhotoModel>>`.
3. Nuovo provider sostituisce l'N+1:
   ```dart
   @Riverpod(keepAlive: true)
   Future<Map<int, List<Photo>>> timelinePhotosByDay(Ref ref) async { ... }
   ```
   popolato in un colpo solo dal `detail`.
4. **Fallback**: se per un giorno `detail == null` o è troncato (`detail.length < count`),
   batchare i giorni mancanti con un solo `POST /days` multi-`dayId`:
   - `TimelineRemoteDatasource.getDaysPhotos(List<int> dayIds)` → `POST /days` con
     `{'dayIds': [...]}` (l'endpoint accetta già più id, vedi `api_documentation.md:109`).
5. `_DaySection` (`timeline_screen.dart:75`) non watcha più `dayPhotosProvider(dayId)`:
   legge la lista dal provider mappa (`ref.watch(timelinePhotosByDayProvider).valueOrNull?[dayId]`).

**Edge**: il `detail` può essere limitato dalla config server → mantenere il path
`POST /days` per giorno come fallback (riusato anche da Sync T8).

**Verifica**: aprire la timeline genera 1 `GET /days` (+ al massimo 1 `POST /days` di
batch per i giorni troncati), non più una richiesta per sezione visibile.

---

### T3 — Batch local-path (N+1 DB → 1 query)
**Perché**: `_enrichWithLocalPaths` (`timeline_provider.dart:56`) chiama
`getLocalPath(fileId)` per ogni foto.

**Come**:
- In `sync_local_datasource.dart`, nuovo metodo:
  ```dart
  Future<Map<int, String>> getLocalPaths(Set<int> fileIds) async {
    if (fileIds.isEmpty) return {};
    final rows = await (_db.select(_db.syncCacheEntries)
          ..where((t) => t.fileId.isIn(fileIds))).get();
    final byFile = <int, String>{};
    for (final e in rows) {
      // preferisci l'originale (downloadFull) alla preview
      if (e.downloadFull || !byFile.containsKey(e.fileId)) {
        byFile[e.fileId] = e.localPath;
      }
    }
    return byFile;
  }
  ```
- Esporre `getLocalPaths` su `ISyncRepository` + impl (`sync_repository_impl.dart`).
- `_enrichWithLocalPaths` fa una sola chiamata e mappa in memoria.

**Verifica**: nessun aumento di query DB al crescere delle foto del giorno.

---

### T4 — `ref.keepAlive()` sui provider di rete
**Perché**: regola CLAUDE.md; evita refetch a ogni navigazione.

**Come**: i nuovi provider (`timelineRepository`, `timelinePhotosByDay`) sono già
`@Riverpod(keepAlive: true)`. Per `timelineDays` aggiungere `ref.keepAlive()` in `build`
o convertirlo a `keepAlive: true`. Invalidazione esplicita resta sul pull-to-refresh
(`ref.invalidate(...)` in `timeline_screen.dart:25`).

---

### T5 — Thumbnail più piccole + header sollevati
**Perché**: griglia a 3 colonne riceve immagini 512px; credenziali ricalcolate per build.

**Come**:
- `_PhotoTile` (`timeline_screen.dart:152`): preview `x=256&y=256` (la griglia è ~130px
  su device tipici; 256 copre il dpr). Per il viewer full-screen restare a 1920.
- Calcolare `credentials`/`httpHeaders` una volta a monte (es. provider derivato dalla
  config o campo del `_TimelineList`) e passarli giù, invece di
  `base64Encode(...)` in ogni `build` di tile.
- Opzionale: `cacheWidth`/`memCacheWidth` su `CachedNetworkImage` per limitare il decode
  in memoria.

**Verifica**: ridotta banda e memoria nella griglia; scroll più fluido.

---

## SYNC

### S6 — Download paralleli (worker pool a concorrenza limitata)
**Perché**: `runSync` (`sync_repository_impl.dart:124`) scarica un file per volta.

**Come**:
- Sostituire il `for ... await` con un pool a concorrenza fissa (default 5, costante
  configurabile). Schema senza dipendenze esterne:
  ```dart
  const concurrency = 5;
  final queue = Queue.of(toDownload);
  Future<void> worker() async {
    while (queue.isNotEmpty) {
      final photo = queue.removeFirst();
      try { ...download + insertOrUpdateCacheEntry...; downloaded++; }
      catch (_) { failed++; }
      // emit progress (vedi sotto)
    }
  }
  await Future.wait(List.generate(concurrency, (_) => worker()));
  ```
- **Progress thread-safe**: `runSync` è `async*`; non si può `yield` dentro i worker.
  Usare uno `StreamController<SyncProgress>` interno: i worker fanno `controller.add(...)`
  con contatori aggiornati in modo atomico (single-thread isolate, quindi `downloaded++`
  è sicuro), e `runSync` fa `yield*` dal controller. `SyncProgressNotifier`
  (`sync_progress_provider.dart`) non cambia.
- Rispettare i limiti server: su 429/503 ridurre la concorrenza o backoff (vedi S6b).

**S6b (opzionale) — retry/backoff**: wrappare ogni download con retry esponenziale
(2-3 tentativi) su errori di rete/503 prima di contare `failed`.

**Verifica**: tempo totale di sync di N file ≈ N/concurrency × tempo medio; progress
continua a salire monotòno.

---

### S7 — `/api/stream/{fileid}` per gli originali
**Perché**: `downloadOriginal` (`sync_download_datasource.dart:94`) fa
`GET /image/info/{id}` solo per ricavare il path WebDAV, poi scarica via WebDAV.

**Come (aggressivo)**:
- Aggiungere `MemoriesApi.stream(int fileId) => '$basePath/stream/$fileId';`
- Riscrivere `downloadOriginal` con un solo `_dio.download(MemoriesApi.stream(fileId), partPath)`.
  Niente più chiamata `info`, niente `webdav.Client`.
- Rimuovere `_buildWebdavClient`/`_webdav` se non più usato altrove (verificare
  riferimenti prima di togliere `webdav_client` dal `pubspec`).
- Supporta Range (`api_documentation.md:549`) → abilita resume del `.part` in futuro.

**Edge**: confermare che `/api/stream` esista sulla versione Memories del server target
(alcune versioni usano `/api/download`); altrimenti fallback al path attuale.

**Verifica**: un download originale = 1 sola richiesta HTTP (oggi 2 + WebDAV).

---

### S8 — Batch `_getExpectedPhotos`
**Perché**: `_getExpectedPhotos` (`sync_repository_impl.dart:241`) per le regole
`time_range` cicla i giorni con `getDayPhotos` sequenziale.

**Come**:
- Riusare `TimelineRemoteDatasource.getDaysPhotos(List<int> dayIds)` di T2: ottenere i
  `dayId` ≥ cutoff e fare 1 (o pochi) `POST /days` multi-id invece di N richieste.
- In alternativa, se la timeline carica già `detail` (T2), leggere da
  `timelinePhotosByDay` evitando del tutto la rete.

**Verifica**: numero di richieste per il calcolo "expected" indipendente dal numero di
giorni nel range.

---

### S9 — `multipreview` per i batch di anteprime (preview-mode)
**Perché**: regole non-`downloadFull` scaricano un thumbnail per richiesta.

**Come (aggressivo)**:
- `POST /api/image/multipreview` con body `{files:[{reqid,fileid,x,y,a}]}`
  (`api_documentation.md:221`).
- Parsing del framing binario per ogni frame: `1 byte len JSON` → `JSON {reqid,len,type}`
  → `len` byte di immagine. Implementare un parser su `ResponseType.bytes`.
- Batch di ~20-50 file per richiesta; scrivere ogni immagine nel rispettivo
  `.part`→rename e poi `insertOrUpdateCacheEntry`.
- Integrare nel pool S6: i batch sostituiscono i singoli `downloadPreview`.

**Verifica**: download di K anteprime = ceil(K/batch) richieste invece di K.

---

### S10 — Batch query di pruning / reference counting
**Perché**: il pruning (`sync_repository_impl.dart:170`) e `deleteSyncRule:62` fanno
`countRefs` per ogni entry in un loop.

**Come**:
- Aggiungere in `sync_local_datasource.dart` un conteggio aggregato per molti fileId:
  `SELECT fileId, count(*) ... WHERE fileId IN (...) GROUP BY fileId, downloadFull`
  (drift: `selectOnly` + `groupBy`), così il reference counting è 1 query.
- Cancellazioni file: raccogliere i path da eliminare e farlo in un solo passaggio.

**Verifica**: numero di query di pruning costante rispetto al numero di entry.

---

## BACKLOG (migliorie future)

### T6 — Caricamento windowed + jump-to-date
**Problema**: `getTimeline()` carica in un'unica passata **tutte** le foto di **tutti** i
giorni (un grande `GET /days` con `detail` + un batch `POST /days`). Conseguenza: per
raggiungere una data lontana l'utente deve aspettare che si carichi tutto ciò che la
precede; la prima apertura a freddo scarica un payload enorme e tiene tutte le foto in
memoria.

**Obiettivo**: caricare solo la "finestra" visibile e poter saltare a una data senza
caricare tutto il pregresso.

**Possibili approcci** (da valutare):
1. **Lista giorni leggera + foto on-demand a finestra**: caricare subito solo la lista
   giorni con il `count` (`GET /days?nopreload=1`, risposta piccola), riservare per ogni
   sezione l'altezza stimata dal `count` (placeholder a dimensione fissa, così la
   scrollbar è stabile), e caricare le foto dei soli giorni che entrano/stanno per entrare
   nel viewport — batchando i `dayId` vicini in un'unica `POST /days`. È il modello della
   web-app Memories.
2. **Jump-to-date / scrubber**: barra di scorrimento rapida con bollino data; al rilascio
   si caricano le foto del giorno target (e dei vicini) on-demand, senza toccare il
   pregresso.
3. **Paginazione incrementale**: caricare i giorni a blocchi (es. 30 giorni per volta) con
   infinite scroll, mantenendo la cache-first per i blocchi già visti.

**Note**:
- Va conciliato con la cache-first attuale (Hive): la finestra caricata si aggiunge/aggiorna
  la cache per giorno (`savePhotosForDay`), già disponibile.
- Tornare a un caricamento per-giorno reintroduce il rischio N+1: mitigare batchando i
  `dayId` della finestra in una sola `POST /days` (riusa `getDaysPhotos`).
- Misura di riferimento: aprire una data a fondo timeline non deve dipendere dal numero di
  foto che la precedono.

---

## Ordine consigliato e dipendenze
1. **T1** (base: datasource condiviso) →
2. **T2** (richiede T1; introduce `getDaysPhotos` riusato da S8) →
3. **T3**, **T4**, **T5** (indipendenti tra loro) →
4. **S6** (parallelismo, il maggior guadagno sul sync) →
5. **S7** (originali via stream) →
6. **S8** (riusa T2) →
7. **S9**, **S10** (opzionali/raffinamenti).

## Rischi e mitigazioni
- **`detail` inline limitato** dalla config server → fallback `POST /days` batch (T2).
- **`/api/stream` / `multipreview`** dipendono dalla versione Memories → feature-flag o
  fallback ai path attuali; testare su server reale.
- **Concorrenza sync** → 429/503: parallelismo configurabile + backoff (S6b).
- **Cache metadati**: `_dayToMap` (`photo_metadata_cache.dart:129`) non salva `detail`;
  se si vuole timeline offline completa, valutare di persistere anche le foto per giorno
  (già esiste `savePhotosForDay`).

## Test
- `test/features/timeline/` e `test/features/sync/`: aggiungere test su
  `getDaysPhotos` (batch), `getLocalPaths` (mappa), e sul pool di download (conteggi
  downloaded/failed con un datasource fake).
