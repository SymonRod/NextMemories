# Feature: Album

## Panoramica

Permette di sfogliare gli album Nextcloud Memories. Mostra una griglia 2 colonne con copertina, nome e conteggio foto. Ogni album si apre in una schermata di dettaglio con griglia 3 colonne; da lì si accede al viewer fullscreen con swipe.

Supporta **selezione multipla** per aggiungere o rimuovere foto dagli album direttamente dall'app.

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
│       ├── get_album_photos_use_case.dart
│       ├── add_photos_to_album_use_case.dart
│       └── remove_photos_from_album_use_case.dart
└── presentation/
    ├── providers/albums_provider.dart
    ├── screens/
    │   ├── albums_screen.dart
    │   ├── album_detail_screen.dart
    │   └── album_viewer_screen.dart
    └── widgets/
        └── album_picker_sheet.dart
```

---

## API utilizzate

| Metodo | Path | Descrizione |
|---|---|---|
| GET | `/apps/memories/api/clusters/albums` | Lista album |
| GET | `/apps/memories/api/days?albums={clusterId_encoded}` | Foto di un album |
| SEARCH | `/remote.php/dav` | Risolve fileId → path WebDAV (body XML) |
| COPY | `/remote.php/dav/files/{user}/{path}` | Aggiunge una foto a un album |
| DELETE | `/remote.php/dav/photos/{user}/albums/{name}/{fileId}-{basename}` | Rimuove una foto dall'album |

### SEARCH — Risoluzione fileId → path

Usata prima di COPY per ottenere il path DAV di ogni foto selezionata.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<d:searchrequest xmlns:d="DAV:" xmlns:oc="http://owncloud.org/ns" ...>
  <d:basicsearch>
    <d:select><d:prop><oc:fileid /></d:prop></d:select>
    <d:from><d:scope><d:href>/files/{username}</d:href><d:depth>0</d:depth></d:scope></d:from>
    <d:where>
      <d:or>
        <d:eq><d:prop><oc:fileid/></d:prop><d:literal>1062223</d:literal></d:eq>
      </d:or>
    </d:where>
  </d:basicsearch>
</d:searchrequest>
```

Risposta `207 Multi-Status` — ogni `<d:response>` contiene `<d:href>` (path) e `<oc:fileid>`.

### COPY — Aggiunta foto all'album

```
COPY /remote.php/dav/files/{user}/path/to/photo.jpg
Destination: https://{server}/remote.php/dav/photos/{user}/albums/{albumName}/photo.jpg
```

- Risposta `201 Created` in caso di successo.
- **409 Conflict** = foto già presente nell'album → trattato come successo (ignorato).
- Il `Destination` è un URL assoluto. Sia il nome album sia il basename vengono URL-encoded (`Uri.encodeComponent`). Il basename nell'href dalla SEARCH è già encoded: va decoded prima di re-encodarlo per evitare double-encoding.

### DELETE — Rimozione foto dall'album

```
DELETE /remote.php/dav/photos/{user}/albums/{albumName}/{fileId}-{basename}
```

Il filename nell'album ha sempre il formato `{fileId}-{basename}` (es. `1062223-photo.jpg`).

- **404** = foto non presente → ignorato silenziosamente.

---

## Selezione multipla

La selezione è gestita da un `StateProvider<Set<int>>` globale condiviso tra Timeline e Album Detail.

```dart
// lib/features/timeline/presentation/providers/selection_provider.dart
final selectionProvider = StateProvider<Set<int>>((ref) => const {});
```

### UX

- **Long press** su una foto → entra in modalità selezione (aggiunge al set)
- **Tap** in modalità selezione → toggle (aggiunge/rimuove dal set)
- **Tap X** in AppBar → cancella selezione ed esce dalla modalità
- **Barra azioni** in basso compare quando `selection.isNotEmpty`

### Azioni contestuali

| Schermata | Azioni disponibili |
|---|---|
| Timeline | Aggiungi ad album |
| Album Detail | Rimuovi dall'album (primario) · Aggiungi ad altro album (icona secondaria) |

### Flusso "Aggiungi ad album"

1. Utente preme "Aggiungi ad album" → si apre `AlbumPickerSheet` (bottom sheet con lista album)
2. Utente sceglie un album
3. Notifier cattura i riferimenti **prima** di azzerare la selezione (azzerare rimuove la barra dal widget tree e invalida `ref`)
4. Selezione azzerata → `AddPhotosToAlbum.add(albumName, fileIds)`
5. Internamente: SEARCH per risolvere fileIds → path, poi COPY per ogni file

### Flusso "Rimuovi dall'album"

1. Utente preme "Rimuovi dall'album"
2. I fileId selezionati vengono mappati a `{fileId: basename}` leggendo la lista foto già caricata
3. Notifier cattura i riferimenti prima di azzerare la selezione
4. `RemovePhotosFromAlbum.remove(albumName, clusterId, fileIdToBasename)`
5. DELETE per ogni file; poi `ref.invalidate(albumPhotosProvider(clusterId))` per aggiornare la griglia

---

## Notifiche globali

Le azioni di modifica album usano il `NotificationService` globale (vedi sezione dedicata in [architettura](../architettura.md)):

| Evento | Tipo | Messaggio |
|---|---|---|
| Operazione in corso | Info (blu) | "Aggiungendo N foto…" / "Rimozione di N foto…" |
| Successo | Success (verde) | "N foto aggiunte a «Album»" / "N foto rimosse da «Album»" |
| Errore | Error (rosso) | Messaggio di errore dal server |

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
ref.watch(albumsProvider)                    // Stream<List<Album>>

// Foto di un album (keepAlive)
ref.watch(albumPhotosProvider(clusterId))    // Stream<List<Photo>>

// Notifier: aggiunge foto a un album
ref.read(addPhotosToAlbumProvider.notifier).add(albumName, fileIds)

// Notifier: rimuove foto da un album
ref.read(removePhotosFromAlbumProvider.notifier).remove(albumName, clusterId, fileIdToBasename)
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

## Note implementative

- Il campo `cover` è sempre `null` — usare `last_added_photo` + `last_added_photo_etag` come copertina.
- Gli album con `name` che inizia con `.link-` sono link condivisi: vengono filtrati nel datasource.
- `cluster_id` ha il formato `username/album_name` (es. `rod/Sardegna Estate 24`): va URL-encoded con `Uri.encodeComponent()`.
- La `AlbumPickerSheet` carica la lista album da `albumsProvider` già in cache — il bottom sheet è istantaneo.
- **Attenzione ref dopo dispose**: azzerare `selectionProvider` rimuove `_SelectionBar` dal tree. Tutti i `ref.read(...)` necessari vanno catturati **prima** dell'azzeramento, non dopo un `await`.

---

## Performance

- **T3 (batch local-path)** — ✅ `_withLocalPaths` usa `syncRepo.getLocalPaths(Set<int>)` (una query) invece di una query per foto.
- **T5 (thumbnail)** — ✅ griglia a 256px con `memCacheWidth/memCacheHeight: 256` in `album_detail_screen`.
- **Cache offline / stale-while-revalidate** — già presente in `albumsProvider`/`albumPhotosProvider` (prefetch foto in background).

## Dipendenze da altre feature

- `Photo` entity e `PhotoModel` condivisi da `features/timeline/`
- `selectionProvider` da `features/timeline/presentation/providers/`
- `AuthInterceptor` da `core/api/`
- `NotificationService` da `core/services/`
- `FavoriteProvider` da `features/viewer/` per il pulsante preferiti nel viewer
