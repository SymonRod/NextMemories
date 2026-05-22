# NextMemories

App mobile Flutter per sfogliare, sincronizzare e visualizzare foto da [Nextcloud Memories](https://memories.gallery).
Funziona offline tramite cache locale. Target primario: Android.

## Documentazione

Tutta la documentazione tecnica è in [`docs/`](docs/index.md):

- [Architettura](docs/architettura.md) — FFCA, layer, convenzioni
- [API Nextcloud](docs/api.md) — endpoint Memories API e OCS
- [Ambiente di sviluppo](docs/sviluppo.md) — setup, build, hot reload
- [Feature: Auth](docs/features/auth.md)
- [Feature: Profile](docs/features/profile.md)

## Avvio rapido

```bash
# Installa dipendenze
flutter pub get

# Avvia su device connesso
flutter run -d <device-id>

# Code generation (dopo modifiche a model/entity/provider)
flutter pub run build_runner build --delete-conflicting-outputs
```

## Stack

Flutter · Riverpod · GoRouter · Dio · Drift · Freezed

---

> NextMemories is an unofficial client and is not affiliated with Nextcloud GmbH or the [Nextcloud Memories](https://memories.gallery) project.
