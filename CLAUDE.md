# NextMemories — CLAUDE.md

## Panoramica progetto
App mobile Flutter per sfogliare, sincronizzare e visualizzare foto da Nextcloud Memories.
Funziona offline tramite cache locale. Supporta widget Android per homescreen.
Target primario: Android. iOS da tenere in mente (no codice iOS-specific per ora, ma niente che lo precluda).

---

## Architettura

Feature-First Clean Architecture (FFCA).

```
lib/
├── core/
│   ├── api/          # Client HTTP, WebDAV, interceptors
│   ├── auth/         # Token Nextcloud, OAuth2
│   ├── cache/        # Gestione cache locale (immagini + DB)
│   ├── error/        # Failure classes, error handling
│   └── utils/        # Extensions, helpers
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── timeline/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── albums/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── viewer/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── sync/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

Ogni feature ha:
- `data/` → datasources, repositories impl, models (JSON serialization)
- `domain/` → entities, repository interfaces, use cases
- `presentation/` → screens, widgets, providers (Riverpod)

---

## Stack tecnico

### State Management
**Riverpod** (riverpod_annotation + code generation).
- Usare `@riverpod` annotation sempre
- Preferire `AsyncNotifierProvider` per stato asincrono
- `StateProvider` solo per stato UI semplice (es. tab selezionata)
- Mai usare `ChangeNotifier` o `setState` salvo casi eccezionali giustificati

### Navigazione
**GoRouter** con route dichiarative.
- Definire tutte le route in `core/router/app_router.dart`
- Usare `ShellRoute` per la bottom navigation
- Nessun `Navigator.push` diretto nel codice

### Networking
**Dio** per chiamate HTTP REST alle Memories API.
**webdav_client** per operazioni WebDAV (download file, listing).
- Tutti gli endpoint Nextcloud Memories in `core/api/memories_api.dart`
- Interceptor per auth token in `core/api/auth_interceptor.dart`

### Persistenza locale
**Drift** (SQLite) per metadati foto, album, stato sync.
- **Hive** per preferenze utente e configurazione server
- **flutter_cache_manager** + filesystem per cache immagini

### Immagini
**cached_network_image** per display con cache automatica.
**photo_manager** per accesso MediaStore Android (foto locali, salvataggio nel rullino).

### Widget Android
**home_widget** come bridge Flutter ↔ AppWidgetProvider Kotlin.
Il codice Kotlin per i widget sta in `android/app/src/main/kotlin/.../widgets/`.
Comunicazione dati via `HomeWidget.saveWidgetData`.

---

## Dipendenze principali (pubspec.yaml)

```yaml
dependencies:
  # State management
  flutter_riverpod: ^2.x
  riverpod_annotation: ^2.x

  # Navigation
  go_router: ^14.x

  # Networking
  dio: ^5.x
  webdav_client: ^1.2.2

  # Persistenza
  drift: ^2.x
  hive_flutter: ^1.x
  flutter_cache_manager: ^3.x

  # Immagini
  cached_network_image: ^3.x
  photo_manager: ^3.x

  # Widget Android
  home_widget: ^0.x

  # Utility
  freezed_annotation: ^2.x
  json_annotation: ^4.x
  fpdart: ^1.x          # Functional: Either, Option

dev_dependencies:
  riverpod_generator: ^2.x
  build_runner: ^2.x
  freezed: ^2.x
  json_serializable: ^6.x
  drift_dev: ^2.x
```

---

## Convenzioni codice

### Naming
- File: `snake_case.dart`
- Classi: `PascalCase`
- Variabili/metodi: `camelCase`
- Provider Riverpod: suffisso `Provider` (es. `timelineProvider`)
- Use case: verbo + sostantivo (es. `GetTimelineUseCase`, `SyncPhotosUseCase`)
- Repository interface: `I` prefix (es. `IPhotosRepository`)

### Modelli
- Usare **Freezed** per tutte le entity e i data model
- Serializzazione JSON con `json_serializable`
- Mai classi mutabili per entity di dominio

### Error handling
- Usare `Either<Failure, T>` da `fpdart` nei repository e use case
- Mai `throw` nel layer domain/data — restituire `Left(failure)`
- Failure classes in `core/error/failures.dart`

### Async
- Preferire `AsyncValue` di Riverpod per gestire loading/error/data in UI
- Mai `FutureBuilder` o `StreamBuilder` raw — usare Riverpod

---

## Nextcloud Memories API

Base URL: `https://{server}/apps/memories/api`

Endpoint principali:
```
GET  /days                    # Timeline (lista giorni con foto)
GET  /days/{dayId}            # Foto di un giorno specifico
GET  /albums                  # Lista album
GET  /albums/{albumId}        # Foto di un album
GET  /photo/{fileId}/info     # Metadati foto
GET  /photo/{fileId}/preview  # Thumbnail
```

WebDAV base: `https://{server}/remote.php/dav/files/{username}/`

Auth: Basic Auth o App Password Nextcloud (preferire App Password).
Salvare credenziali in **Flutter Secure Storage**, mai in Hive o SharedPreferences.

---

## Funzionalità da implementare (in ordine)

1. **Auth** — configurazione server URL + app password, validazione connessione
2. **Timeline** — lista foto per data, scroll infinito, thumbnail lazy load
3. **Viewer** — visualizzazione foto full screen, zoom, swipe tra foto
4. **Sync** — download selettivo foto in cache locale, accesso offline
5. **Album** — lista e sfoglio album
6. **MediaStore** — salvataggio foto nel rullino Android via photo_manager
7. **Widget Android** — "Memoria del giorno" e "Ultima foto"

---

## Ambiente di sviluppo

### JDK
Usare **OpenJDK 21** (`/usr/lib/jvm/java-21-openjdk`).
Configurato in `~/.gradle/gradle.properties` (user-level, non nel repo):
```properties
org.gradle.java.home=/usr/lib/jvm/java-21-openjdk
```

### Emulatore Android
`flutter run -d emulator-5554` — emulatore Android 17 (API 37).
Lanciare sempre dal terminale per avere hot reload (`r`) disponibile.

---

## Documentazione

La documentazione tecnica dettagliata è in `docs/`:

- `docs/index.md` — indice e stato feature
- `docs/architettura.md` — FFCA, layer, convenzioni codice
- `docs/api.md` — endpoint Nextcloud Memories API e OCS
- `docs/sviluppo.md` — setup ambiente, build, code generation
- `docs/features/auth.md` — feature Auth
- `docs/features/profile.md` — feature Profile

Quando si aggiunge o modifica una feature, aggiornare il doc corrispondente in `docs/features/`.

---

## Regole generali per Claude Code

- **Mai** modificare file generati da build_runner (`.g.dart`, `.freezed.dart`)
- **Sempre** eseguire `flutter pub run build_runner build` dopo modifiche ai model
- Quando crei una nuova feature, creare **sempre** tutte e tre le cartelle (data/domain/presentation) e il relativo `docs/features/{feature}.md`
- I test vanno in `test/features/{feature_name}/`
- Nessuna logica di business nei widget/screen — tutto negli use case e provider
- Commenti in inglese nel codice, documentazione di progetto in italiano
- Quando aggiungi una dipendenza, aggiornare anche questo file nella sezione dipendenze

### Ottimizzazioni obbligatorie (da applicare sempre)

- **Dio non va mai ricreato come getter** — ogni datasource deve inizializzare `_dio` come `late final` con un metodo `_buildDio()`. Ricrearlo a ogni chiamata apre una nuova connessione TCP e azzera il connection reuse.
- **Datasource come campo del notifier, non variabile locale** — nei Riverpod `AsyncNotifier`, istanziare il datasource una sola volta in `build` e salvarlo in un campo privato (`_ds`). Non ricostruirlo in ogni metodo.
- **`ref.keepAlive()` sui provider con chiamate di rete costose** — se un provider fa chiamate di rete al primo load (es. fetch info + PROPFIND), aggiungere `ref.keepAlive()` in `build` per evitare che Riverpod lo disponga e lo ricostruisca a ogni navigazione.