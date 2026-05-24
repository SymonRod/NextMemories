# NextMemories — Documentazione

App mobile Flutter per sfogliare, sincronizzare e visualizzare foto da Nextcloud Memories.

## Indice

| Documento | Contenuto |
|---|---|
| [Architettura](architettura.md) | FFCA, layer, convenzioni codice |
| [API Nextcloud](api.md) | Endpoint Memories API e OCS |
| [Ambiente di sviluppo](sviluppo.md) | Setup JDK, emulatore, build |
| [Feature: Auth](features/auth.md) | Login, credenziali, pre-fill last config |
| [Feature: Profile](features/profile.md) | Profilo utente Nextcloud, quota storage |
| [Feature: Timeline](features/timeline.md) | Griglia foto per giorno, lazy load |
| [Feature: Viewer](features/viewer.md) | Fullscreen, zoom, swipe, preferiti |
| [Feature: Album](features/albums.md) | Lista album, griglia foto, viewer |
| [Feature: Sync](features/sync.md) | Cache offline per album e time range |

## Stato feature

| Feature | Stato | Note |
|---|---|---|
| Auth | Completa | Pre-fill credenziali al logout |
| Profile | Completa | |
| Timeline | Completa (online-only) | Cache offline pianificata in Sync |
| Viewer | Completa | Zoom/swipe e preferiti funzionanti |
| Sync | In sviluppo | Backend completo (schema, domain, data layer, test); manca la presentation (provider + UI) — vedi [sync.md](features/sync.md) |
| Album | Completa (online-only) | Griglia, dettaglio, viewer con preferiti |
| MediaStore | Da implementare | |
| Widget Android | Da implementare | |
