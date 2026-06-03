# NextMemories — Documentazione

App mobile Flutter per sfogliare, sincronizzare e visualizzare foto da Nextcloud Memories.

## Indice

| Documento | Contenuto |
|---|---|
| [Architettura](architettura.md) | FFCA, layer, convenzioni codice |
| [API Nextcloud](api.md) | Endpoint Memories API e OCS |
| [Piano performance](performance_plan.md) | Ottimizzazioni Sync & Timeline (stato T1–T5, S6–S10) |
| [Ambiente di sviluppo](sviluppo.md) | Setup JDK, emulatore, build |
| [Feature: Auth](features/auth.md) | Login, credenziali, pre-fill last config |
| [Feature: Profile](features/profile.md) | Profilo utente Nextcloud, quota storage |
| [Feature: Timeline](features/timeline.md) | Griglia foto per giorno, lazy load, selezione multipla |
| [Feature: Viewer](features/viewer.md) | Fullscreen, zoom, swipe, preferiti |
| [Feature: Album](features/albums.md) | Lista album, griglia foto, viewer, selezione multipla |
| [Feature: Sync](features/sync.md) | Cache offline per album e time range |
| [Feature: Widget Album](features/widget_album.md) | Widget homescreen "cornice digitale" di un album sincronizzato |

## Stato feature

| Feature | Stato | Note |
|---|---|---|
| Auth | Completa | Pre-fill credenziali al logout |
| Profile | Completa | |
| Timeline | Completa | Cache metadati offline (Hive) + ottimizzazioni perf (T1–T5) + selezione multipla (aggiungi ad album, condividi) |
| Viewer | Completa | Zoom/swipe e preferiti funzionanti |
| Sync | Completa | Regole album/time range, download selettivo, banner di progresso — vedi [sync.md](features/sync.md) |
| Album | Completa | Griglia, dettaglio, viewer. Selezione multipla: aggiungi ad album (COPY WebDAV) e rimuovi (DELETE WebDAV). Notifiche globali colorate. |
| MediaStore | Da implementare | |
| Widget Android | MVP + F1 + F2 completi | Widget "cornice digitale" album: picker album con thumbnail, configurazione per-istanza, long-press per cambiare album, refresh automatico, tap sulla foto = shuffle in-place senza aprire l'app (F2) / tap sul nome = apre l'album — vedi [widget_album.md](features/widget_album.md). Follow-up: refresh periodico WorkManager (F3) |
