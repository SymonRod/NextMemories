# Feature: Album

## Panoramica

Permette di sfogliare gli album Nextcloud Memories. Mostra una griglia 2 colonne con copertina, nome e conteggio foto. Ogni album si apre in una schermata di dettaglio con griglia 3 colonne; da lì si accede al viewer fullscreen con swipe.

---

## Architettura

```
lib/features/albums/
├── data/
│   ├── datasources/albums_remote_datasource.dart
│   ├── models/album_model.dart
│   └── repositories/albums_repository_impl.dart
├── domain/
│   ├── entities/album.dart
│   ├── repositories/i_albums_repository.dart
│   └── usecases/
│       ├── get_albums_use_case.dart
│       └── get_album_photos_use_case.dart
└── presentation/
    ├── providers/albums_provider.dart
    └── screens/
        ├── albums_screen.dart
        ├── album_detail_screen.dart
        └── album_viewer_screen.dart
```

---

## API utilizzate

| Metodo | Path | Descrizione |
|---|---|---|
| GET | `/apps/memories/api/clusters/albums` | Lista album |
| GET | `/apps/memories/api/days?albums={clusterId_encoded}` | Foto di un album |

### Note importanti

- Il campo `cover` è sempre `null` — usare `last_added_photo` + `last_added_photo_etag` come copertina.
- Gli album con `name` che inizia con `.link-` sono link condivisi: vengono filtrati nel datasource.
- Le foto dell'album arrivano tramite `GET /days?albums=...`, stessa struttura di `/days` ma con `detail` sempre popolato.
- `cluster_id` ha il formato `username/album_name` (es. `rod/Sardegna Estate 24`): va URL-encoded con `Uri.encodeComponent()`.

---

## Entity: Album

```dart
Album({
  required String clusterId,    // es. "rod/Sardegna Estate 24"
  required String name,         // es. "Sardegna Estate 24"
  required int count,           // numero di foto
  required int lastAddedPhoto,  // fileId cover
  String? lastAddedPhotoEtag,   // etag cover
})
```

---

## Provider

```dart
// Lista album (filtrata .link-)
ref.watch(albumsProvider)  // AsyncValue<List<Album>>

// Foto di un album (con keepAlive per evitare reload su navigazione)
ref.watch(albumPhotosProvider(clusterId))  // AsyncValue<List<Photo>>
```

---

## Navigazione

| Route | Extra | Screen |
|---|---|---|
| `/albums` | — | `AlbumsScreen` |
| `/album-detail` | `{clusterId, name}` | `AlbumDetailScreen` |
| `/album-viewer` | `{clusterId, albumName, index}` | `AlbumViewerScreen` |

Le route `/album-detail` e `/album-viewer` usano `extra` (Map) perché `clusterId` contiene `/` e spazi che causerebbero problemi come path/query param con GoRouter.

---

## Dipendenze da altre feature

- `Photo` entity e `PhotoModel` condivisi da `features/timeline/`
- `AuthInterceptor` da `core/api/`
- `FavoriteProvider` da `features/viewer/` per il pulsante preferiti nel viewer
