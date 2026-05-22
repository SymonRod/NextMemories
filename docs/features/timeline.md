# Feature: Timeline

## Stato
Implementata (online-only, no cache offline).

## Descrizione
Visualizza le foto raggruppate per giorno in ordine cronologico inverso. Le foto del giorno vengono caricate in lazy load man mano che l'utente scrolla.

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
| GET | `/apps/memories/api/days` | Lista giorni con conteggio foto |
| POST | `/apps/memories/api/days` body `{"dayIds":[id]}` | Foto di un giorno (array piatto) |
| GET | `/apps/memories/api/image/preview/{fileId}?c={etag}&x=512&y=512&a=1` | Thumbnail |

## Note implementative

- `dayId` è in **giorni dall'Unix epoch**, non YYYYMMDD
- `dayId` negativi sono validi (foto pre-1970)
- Il GET `/days` può includere `detail` già precaricato per i giorni più recenti (non ancora sfruttato)
- Le thumbnail richiedono `Authorization: Basic ...` negli header HTTP — passato via `httpHeaders` di `CachedNetworkImage`
- Il lazy load è implementato con `SliverChildBuilderDelegate`: le POST partono solo quando il giorno entra nel viewport

## Known issues / TODO

- [ ] Sfruttare il campo `detail` già presente in GET `/days` per i giorni recenti (evita POST aggiuntive)
- [ ] Aggiungere cache offline (Drift) — pianificato nella feature Sync
- [ ] Pull-to-refresh
