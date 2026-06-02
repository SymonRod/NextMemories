# Feature: Widget Album (cornice digitale)

## Obiettivo
Widget Android per la homescreen che mostra, a rotazione, le foto di **un album
sincronizzato offline**. L'utente sceglie quale album mostrare direttamente
dall'app (strada A — nessuna Activity di configurazione nativa nell'MVP).

Tipo widget: **opzione 1** — cornice digitale che ruota le foto dell'album scelto.

## Stato
🚧 In sviluppo — MVP. Fasi 1–5 completate (backend Dart, native Android,
pipeline foto→widget, azione UI "Mostra nel widget", deep link al tap).
Resta: Fase 6 (refresh automatico).

Nota deep link: il tap del widget NON usa il deep linking automatico di Flutter
(disattivato via `flutter_deeplinking_enabled=false` nel Manifest, altrimenti
l'URI `nextmemories://` grezzo arriva a GoRouter e fallisce). Il tap è gestito
in `main.dart` tramite `HomeWidget.initiallyLaunchedFromHomeWidget()` +
`HomeWidget.widgetClicked`. Il `clusterId` è URL-encoded lato Kotlin (può
contenere `/`, es. `rod/Aosta`).

---

## Perché è fattibile con poco backend
La feature `sync` salva già su disco le foto degli album sincronizzati e le
traccia nel DB:

- Tabella `SyncCacheEntries` → `ruleId`, `fileId`, `localPath`, `downloadFull`, `sizeBytes`.
- `SyncLocalDatasource.getCacheEntriesForRule(ruleId)` restituisce tutti i path
  locali delle foto di una regola-album.

Quindi data una regola-album basta leggere le sue cache entries per avere la
lista di foto da mostrare nel widget, **garantite offline**.

---

## Decisioni di design (MVP)

| Tema | Scelta MVP | Follow-up futuro |
|------|-----------|------------------|
| Quale album | **Strada A**: scelto in-app, uno solo condiviso da tutte le istanze | Config Activity nativa per-`appWidgetId` |
| Refresh foto | Al pin, all'apertura app, a sync completata | Tap-to-shuffle (interactivity callback) + WorkManager periodico |
| Scelta foto | Random tra le cache entries dell'album | Sequenziale / "memoria del giorno" |
| Rendering | Bitmap downsampled lato Kotlin (evita `TransactionTooLargeException`) | — |
| Tap sul widget | Apre l'album in app (deep link) | Shuffle in-place |

---

## Architettura

Nuova feature `lib/features/widget/` (FFCA: data / domain / presentation).
Codice nativo Android in `android/app/src/main/kotlin/.../widgets/`.

### Dart — domain
- `entities/widget_album_config.dart` (Freezed): `{ int ruleId, String clusterId, String albumName }`.
- `repositories/i_widget_repository.dart`:
  - `Future<Either<Failure, Option<WidgetAlbumConfig>>> getPinnedAlbum()`
  - `Future<Either<Failure, Unit>> pinAlbum(WidgetAlbumConfig config)`
  - `Future<Either<Failure, Unit>> unpinAlbum()`
  - `Future<Either<Failure, Unit>> refreshWidget()` → sceglie una foto e aggiorna il widget.

### Dart — data
- `datasources/widget_local_datasource.dart`: box **Hive** per la config pinned
  (preferenza utente → Hive, da CLAUDE.md).
- `datasources/home_widget_datasource.dart`: wrapper su `home_widget`
  (`saveWidgetData` per `imagePath` / `albumName` / `clusterId`, poi `updateWidget`).
- `repositories/widget_repository_impl.dart`: orchestrazione. Per `refreshWidget`
  legge le cache entries dell'album (vedi sotto), pesca un path random, lo passa
  al datasource home_widget.

### Dipendenza cross-feature (sync → widget)
Il widget deve leggere i path locali di un album. Per non accoppiarsi al DB,
si aggiunge a `ISyncRepository`:
- `Future<Either<Failure, List<String>>> getLocalPhotoPathsForRule(int ruleId)`
  (impl: `SyncLocalDatasource.getCacheEntriesForRule` → `localPath`).

### Dart — presentation
- `providers/widget_provider.dart`: `@riverpod` `AsyncNotifier` per la config
  pinned + azioni `pin` / `unpin`.
- **Integrazione UI**: in `SyncSettingsScreen._SyncRuleCard`, solo per regole
  `SyncRuleType.album`, aggiungere azione "Mostra nel widget" (toggle/icona) con
  indicatore di pin attivo.

### Native Android (Kotlin)
- `widgets/AlbumWidgetProvider.kt` extends `HomeWidgetProvider`:
  - In `onUpdate`: legge `imagePath`, `albumName`, `clusterId` dai widget data.
  - Carica + **downsampla** la bitmap (`BitmapFactory` con `inSampleSize`) a misura widget.
  - `setImageViewBitmap` + `setTextViewText` + `PendingIntent` (deep link album).
- `res/layout/album_widget.xml`: `ImageView` (foto) + `TextView` overlay (nome album).
- `res/xml/album_widget_info.xml`: metadata `appwidget-provider`
  (minWidth/Height, `resizeMode`, `previewImage`, `updatePeriodMillis=0`).
- `res/drawable/`: preview widget + background arrotondato.
- `AndroidManifest.xml`: `<receiver>` con `APPWIDGET_UPDATE` + meta-data.

### Deep link (tap → apre album)
La route `/album-detail` attuale legge da `state.extra` (Map) → non funziona da
PendingIntent a freddo. Aggiungere supporto query-param:
`/album-detail?clusterId=...&name=...` (o route dedicata `/widget-open`).

---

## Fasi di implementazione

1. **Backend Dart**: feature `widget` (entity, repo, datasources, use case),
   metodo `getLocalPhotoPathsForRule` su sync repo. Build_runner.
2. **Native Android**: provider Kotlin + layout/xml/manifest + preview.
3. **Pipeline foto→widget**: `refreshWidget` end-to-end (pin album → foto sul widget).
4. **Integrazione UI**: azione "Mostra nel widget" nelle card album.
5. **Deep link**: tap widget → apre album.
6. **Refresh automatico**: su app resume + a sync completata.
7. **Doc**: aggiornare `docs/index.md` (stato feature) e questo file.

---

## Verifica
- Sincronizzare un album, fare "Mostra nel widget", aggiungere il widget alla home.
- Verificare che mostri una foto dell'album e il nome.
- Riaprire l'app → la foto cambia (random).
- Tap sul widget → apre l'album in app.
- Album con molte foto ad alta risoluzione → nessun crash (downsampling ok).

## Follow-up (post-MVP)
- Config Activity nativa per-`appWidgetId` (album diversi per istanza).
- Tap-to-shuffle senza aprire l'app (interactivity callback).
- Refresh periodico in background (WorkManager + isolate headless).
