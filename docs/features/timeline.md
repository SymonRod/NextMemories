# Feature: Timeline

## Stato
Implementata, con cache metadati offline (Hive, vedi [Sync](sync.md)) e ottimizzazioni di performance (vedi [performance_plan.md](../performance_plan.md), item T1–T5).

## Descrizione
Visualizza le foto raggruppate per giorno in ordine cronologico inverso. Tutte le foto vengono caricate in **al massimo 2 richieste** (vedi *Caricamento foto*), non più con una POST per giorno.

## Architettura

```
timeline/
├── data/
│   ├── datasources/timeline_remote_datasource.dart
│   └── models/
│       ├── photo_day_model.dart   (Freezed + json_serializable)
│       └── photo_model.dart       (Freezed + json_serializable)
├── domain/
│   ├── entities/
│   │   ├── photo_day.dart
│   │   └── photo.dart
│   ├── repositories/i_timeline_repository.dart
│   └── usecases/
│       ├── get_timeline_days_use_case.dart
│       └── get_day_photos_use_case.dart
└── presentation/
    ├── providers/timeline_provider.dart
    └── screens/timeline_screen.dart
```

## API utilizzate

| Metodo | Endpoint | Descrizione |
|---|---|---|
| GET | `/apps/memories/api/days` | Lista giorni con conteggio foto e `detail` inline (preload) |
| POST | `/apps/memories/api/days` body `{"dayIds":[...]}` | Foto di **più giorni** in un'unica richiesta (fallback batch) |
| GET | `/apps/memories/api/image/preview/{fileId}?c={etag}&x=256&y=256&a=1` | Thumbnail griglia (256px) |

## Caricamento foto (T1–T4)

`getTimeline()` (`TimelineRepositoryImpl`) carica **giorni e foto insieme** con **una sola
fetch `/days`** (prima erano due: una per la lista giorni che scartava il `detail`, una
per riprenderlo):
1. `GET /days` — restituisce sia la lista giorni sia il `detail` inline. Per i giorni con
   `detail` completo (`detail.length >= count`) le foto sono già qui.
2. `POST /days` con i soli `dayId` mancanti/troncati — un unico batch invece di N POST.

Ritorna il record `TimelineData = ({List<PhotoDay> days, Map<int, List<Photo>> photosByDay})`.

### Cache-first (stale-while-revalidate)

`timelineProvider` (`Stream<TimelineData>`, `@Riverpod(keepAlive: true)`) emette **subito**
l'ultima timeline nota dalla cache Hive (giorni + foto), poi rivalida dalla rete in
background e ri-emette solo i dati freschi. Le riaperture dell'app sono quindi istantanee;
la prima apertura assoluta (cache vuota) mostra lo spinner finché arriva la rete. Se la
rete è giù dopo aver mostrato la cache, resta sulla cache (nessun errore).

Provider in `timeline_provider.dart`:
- `timelineRepositoryProvider` (`keepAlive`) — repository condiviso; il `Dio` è
  `late final` nel datasource → una sola istanza ⇒ connection reuse (T1).
- `timelineProvider` (`keepAlive`, stream) — cache-first; persiste days/foto in Hive e
  arricchisce i `localPath` in un'unica query DB (T3).
- `dayPhotosProvider` — usato dal viewer (deep-link/accesso diretto): legge dalla mappa di
  `timelineProvider` se disponibile, altrimenti fa il fetch del singolo giorno.

`keepAlive` (T4) evita il refetch tornando sulla timeline; il refresh resta esplicito
(`ref.invalidate(timelineProvider)`).

## Arricchimento localPath (T3)

`_enrichAllWithLocalPaths` recupera i path locali di **tutte** le foto con una sola query
(`syncRepo.getLocalPaths(Set<int> fileIds)` → `WHERE fileId IN (...)`), non più una query
per foto. I tile usano `Image.file` se `localPath != null`, altrimenti `CachedNetworkImage`.

## Selezione multipla

La struttura dei widget supporta la selezione multipla tramite `selectionProvider`.

### Architettura

```
lib/features/timeline/presentation/providers/selection_provider.dart
  → StateProvider<Set<int>>   // fileId delle foto selezionate (vuoto = non in selezione)
```

Il provider è **globale** — condiviso anche da `AlbumDetailScreen` per le azioni in-album.

### UX nella Timeline

- **Long press** su una foto → aggiunge al set ed entra in modalità selezione
- **Tap** in modalità selezione → toggle (aggiunge / rimuove)
- **AppBar**: mostra "N selezionate" + pulsante X per uscire
- **Barra azioni in basso** (`_SelectionBar`) compare quando `selection.isNotEmpty`

### Azioni disponibili dalla Timeline

| Azione | Descrizione |
|---|---|
| Aggiungi ad album | Apre `AlbumPickerSheet`, poi SEARCH + COPY WebDAV — vedi [albums.md](albums.md) |
| Condividi | Download temporaneo e `share_plus` (originale o preview) |

### Nota: ref dopo dispose

Azzerare `selectionProvider` rimuove `_SelectionBar` dal widget tree e invalida `ref`.
Tutti i `ref.read(...)` vanno catturati **prima** dell'azzeramento:

```dart
final addNotifier = ref.read(addPhotosToAlbumProvider.notifier); // prima
final selectionNotifier = ref.read(selectionProvider.notifier);  // prima
selectionNotifier.state = const {};  // ora il widget è disposto
await addNotifier.add(...);          // ref non usato qui
```

---

## Note implementative

- `dayId` è in **giorni dall'Unix epoch**, non YYYYMMDD
- `dayId` negativi sono validi (foto pre-1970)
- Il campo `detail` di `GET /days` è ora sfruttato (T2): evita POST per i giorni precaricati
- Le thumbnail richiedono `Authorization: Basic ...` negli header HTTP — credenziali e
  `serverUrl` calcolati **una volta** in `_TimelineList` e passati ai tile (non più per build, T5)
- Thumbnail della griglia a 256px con `memCacheWidth/memCacheHeight: 256` (T5)
- `_DaySection` è `StatelessWidget`; `_PhotoTile` è `ConsumerWidget` per leggere `selectionProvider`

## Known issues / TODO

- [x] Sfruttare il campo `detail` di GET `/days` (T2)
- [x] Cache offline metadati (Hive) — vedi [Sync](sync.md), livello metadati
- [x] Selezione multipla + aggiungi ad album
- [x] Condivisione foto
- [ ] Pull-to-refresh
- [ ] **Caricamento windowed / scroll a una data lontana** — oggi `getTimeline()` carica
  *tutte* le foto di *tutti* i giorni in un'unica passata: per arrivare a una data lontana
  bisogna aspettare che si carichi tutto ciò che la precede. Serve un caricamento "a
  finestra" + jump-to-date. Vedi [performance_plan.md](../performance_plan.md), item **T6**.
