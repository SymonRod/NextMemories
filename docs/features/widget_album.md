# Feature: Widget Album (cornice digitale)

## Obiettivo
Widget Android per la homescreen che mostra, a rotazione, le foto di **un album
sincronizzato offline**. L'utente sceglie quale album mostrare direttamente
dall'app (strada A — nessuna Activity di configurazione nativa nell'MVP).

Tipo widget: **opzione 1** — cornice digitale che ruota le foto dell'album scelto.

## Stato
✅ MVP completo (Fasi 1–6).

Refresh automatico (Fase 6): la foto del widget viene rigenerata (random)
quando l'app torna in foreground (`WidgetsBindingObserver` in `main.dart`) e a
fine sincronizzazione (`ref.listen` sulla progress nel widget root, così la
feature `sync` resta ignara del widget). Entrambi i trigger sono protetti da un
check di autenticazione, perché `widgetRepository` dipende dal sync repo
autenticato.

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
| Refresh foto | Al pin, all'apertura app, a sync completata, **tap sulla foto** (F2 ✅) | WorkManager periodico (F3) |
| Scelta foto | Random tra le cache entries dell'album | Sequenziale / "memoria del giorno" |
| Rendering | Bitmap downsampled lato Kotlin (evita `TransactionTooLargeException`) | — |
| Tap sul widget | **Foto = shuffle in-place; nome album = apre l'app** (F2 ✅) | — |

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

Tre estensioni, indipendenti tra loro. Per ognuna: cosa aggiunge, come
implementarla e le insidie.

---

### F1 — Config Activity nativa per-`appWidgetId` (album diversi per istanza)

✅ **Completa.**

Al drag del widget (o long-press → "Modifica widget") si apre
`AlbumWidgetConfigActivity`, che mostra un picker con thumbnail + nome album.
Ogni istanza widget (`appWidgetId`) ricorda il proprio album in modo indipendente.

**Flusso dati Dart → Kotlin:**
- `HomeWidgetDatasource.saveAvailableAlbums` serializza come JSON la lista delle
  sync rules di tipo `album` nella chiave `album_widget_available_albums` delle
  `HomeWidgetPreferences`. Per ogni album include anche `thumbnailPath` (prima
  foto in cache disponibile su disco, ricavata da `getLocalPhotoPathsForRule`).
- La lista viene aggiornata in `main.dart` via `ref.listen` su `syncRulesProvider`,
  così è sempre allineata alle regole di sync correnti.
- `AlbumWidgetConfigActivity` legge il JSON con `org.json.JSONArray`. Comportamento:
  lista vuota → Toast "apri l'app prima"; un solo album → selezione automatica;
  più album → picker visuale.

**Picker visuale (`AlbumPickerAdapter` + `album_picker_item.xml`):**
- `ListView` dentro un `AlertDialog` (no dipendenze extra, solo API Android standard).
- Ogni item: thumbnail 52 dp arrotondata (caricata con `BitmapFactory` + downsampling,
  placeholder `@color/album_thumbnail_placeholder` se il file non esiste) + nome
  album 16 sp su unica riga con ellipsis.
- Tema adattivo: l'Activity usa `Theme.DeviceDefault.NoActionBar` (segue il sistema),
  quindi il dialog è scuro in dark mode. Il colore placeholder è definito in
  `values/colors.xml` (chiaro) e `values-night/colors.xml` (scuro).

**Riconfigurazione (long-press):**
- `album_widget_info.xml` include `android:widgetFeatures="reconfigurable"` (API 28+):
  Android aggiunge automaticamente "Modifica widget" nel menu contestuale del
  long-press, che riapre la config activity sull'istanza esistente.

**Note implementative:**
- Il widget mostra il placeholder fino al prossimo `refreshWidget` (apertura app
  o sync completata), perché al momento della selezione non è ancora disponibile
  un `imagePath` per l'istanza appena creata.
- Se l'utente chiude il picker senza scegliere, `RESULT_CANCELED` impedisce ad
  Android di aggiungere il widget alla homescreen.

---

### F2 — Tap-to-shuffle senza aprire l'app (interactivity callback)

✅ **Completa.**

**Cosa fa.** Due zone di tap sul widget:
- **foto** (`R.id.widget_image`) → cambia foto sul posto, senza aprire l'app;
- **barra col nome album** (`R.id.widget_album_name`) → apre l'album in app
  (deep link MVP). In stato vuoto, il tap apre semplicemente l'app.

**Pipeline condivisa (Nota trasversale).** La logica "scegli foto → aggiorna
widget" è stata estratta in `WidgetRefreshRunner`
(`lib/features/widget/data/widget_refresh_runner.dart`), senza dipendenze da
Riverpod. L'unica I/O iniettata è una `PhotoPathsLookup`: l'app la fornisce dal
sync repository autenticato, l'isolate headless con una lettura Drift diretta
(auth-free). `WidgetRepositoryImpl.refreshWidget` ora delega a
`runner.refreshAll()`; il callback F2 usa `runner.refreshScoped(widgetId)`.

**Lato nativo.** Il tap sulla foto usa
`HomeWidgetBackgroundIntent.getBroadcast(context, Uri.parse("nextmemories://shuffle?widgetId=$widgetId"))`.
Il `widgetId` viaggia nell'URI così il callback aggiorna proprio quell'istanza.
In Manifest sono registrati `HomeWidgetBackgroundReceiver` (broadcast
`es.antonborri.home_widget.action.BACKGROUND`) e `HomeWidgetBackgroundService`
(`BIND_JOB_SERVICE`).

**Lato Dart.** In `main()`:
`HomeWidget.registerInteractivityCallback(widgetBackgroundCallback)`. L'entry-point
(`widget_background_callback.dart`) gira in un isolate headless senza Riverpod e
ricostruisce a mano i datasource: apre una propria connessione Drift, istanzia
`SyncLocalDatasource` per leggere le cache entries della regola, e usa il
`WidgetRefreshRunner` per pescare una foto random e fare `updateWidget`. Il
`FlutterEngine` del service registra automaticamente i plugin, quindi i canali
`HomeWidget` (saveWidgetData/updateWidget) funzionano nell'isolate.

**Niente Hive nel callback.** Per evitare di aprire lo stesso box Hive da due
isolate (non supportato, rischio corruzione), `refreshScoped` legge la config
**solo** dai dati `home_widget` (SharedPreferences, multi-isolate-safe): chiavi
per-`appWidgetId` (F1) con fallback alle chiavi globali. Anche il throttle è su
`home_widget` (`HomeWidgetDatasource.shouldThrottleShuffle`, gap 800 ms) per
assorbire i tap a raffica.

**Drift nell'isolate.** Il callback apre una `AppDatabase()` dedicata, fa solo
**letture** e la chiude in `finally`. SQLite tollera questa connessione in
parallelo a quella dell'app. Il refresh in background NON richiede auth né rete.

**Insidie note.** Limiti di tempo/risorse del background (JobIntentService). Se
in futuro il callback dovesse scrivere sul DB mentre l'app è in foreground,
andrebbe rivista la strategia di concorrenza Drift.

---

### F3 — Refresh periodico in background (WorkManager + isolate headless)

**Cosa aggiunge.** La foto ruota da sola a intervalli (es. ogni ora / una volta
al giorno) anche senza aprire l'app — vera "cornice digitale". Abilita anche la
variante "memoria del giorno" (scelta foto per data invece che random).

**Come.** Aggiungere il package `workmanager`:
1. In `main()`: `Workmanager().initialize(callbackDispatcher)` e
   `Workmanager().registerPeriodicTask("album-widget-refresh", "...",
   frequency: Duration(hours: 1))` (minimo Android = 15 min).
2. Entry-point headless:
   ```dart
   @pragma('vm:entry-point')
   void callbackDispatcher() {
     Workmanager().executeTask((task, _) async {
       // come F2: ricreare i datasource nell'isolate, scegliere la foto,
       // HomeWidget.saveWidgetData + updateWidget.
       return true;
     });
   }
   ```
3. Riuso possibile: estrarre la logica "scegli foto e aggiorna widget" in una
   funzione pura condivisa da WorkManager (F3), interactivity (F2) e app (MVP).

**Insidie.** `updatePeriodMillis` di `appwidget-provider` è un'alternativa nativa
ma con minimo 30 min e poco controllo → WorkManager è preferibile. I vincoli
Doze/battery optimization possono ritardare/saltare le esecuzioni: non garantito
al secondo. Stesso problema di F2 con Hive/Drift nell'isolate. Su Android 12+
attenzione ai limiti su avvii in background. Valutare `existingWorkPolicy` per non
accumulare task duplicati a ogni avvio.

---

### Nota trasversale (F2 + F3)
Sia l'interactivity callback sia WorkManager girano in un **isolate separato**
senza Riverpod. Conviene estrarre la pipeline attuale
(`WidgetRepositoryImpl.refreshWidget`) in una factory che costruisce i datasource
da zero (Hive + Drift + home_widget) senza dipendere dai provider, così la stessa
logica serve MVP, F2 e F3. La credenziale del sync repo non serve per il refresh
(si leggono solo file già in cache): il refresh in background NON richiede auth né
rete, solo accesso al DB e al filesystem.
