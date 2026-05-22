# Feature: Viewer

## Stato
Funzionante — visualizzazione fullscreen, navigazione e preferiti operativi.

## Descrizione
Visualizzatore foto fullscreen con zoom, swipe tra foto dello stesso giorno e toggle preferito.

## Architettura

```
viewer/
├── data/
│   └── datasources/favorite_remote_datasource.dart
└── presentation/
    ├── providers/favorite_provider.dart
    └── screens/viewer_screen.dart
```

## Navigazione

Rotta: `/viewer?dayId={dayId}&index={photoIndex}`

Aperto da `_PhotoTile` nella timeline screen via `context.push(...)`.

## Funzionalità implementate

- Visualizzazione fullscreen con sfondo nero
- `PageView` per swipe sinistra/destra tra le foto del giorno
- `InteractiveViewer` per pinch-to-zoom (max 5x)
- Tap per mostrare/nascondere AppBar e contatore
- AppBar con nome file e pulsante stella (preferito)
- Immagine a risoluzione `1920x1920` (vs 512x512 della griglia)

## Preferiti

### Flusso
1. `GET /apps/memories/api/image/info/{fileId}` → ottiene `filename` (path WebDAV completo, es. `/InstantUpload/Camera/20260522_200132.jpg`). La risposta **non include** lo stato preferito.
2. `PROPFIND /remote.php/dav/files/{username}{filename}` con `Depth: 0` → legge la proprietà `oc:favorite` (valore `0` o `1`).
3. `PROPPATCH /remote.php/dav/files/{username}{filename}` con body XML `oc:favorite` → imposta/rimuove preferito.

### Struttura risposta `/image/info/{fileId}`

```json
{
  "fileid": 1060719,
  "dayid": 20595,
  "w": 3000,
  "h": 4000,
  "datetaken": 1779480092,
  "exif": { "Make": "samsung", "Model": "Galaxy S25 Ultra", ... },
  "etag": "9bb6d1180e9c9421b13d8ff537ccd8d3",
  "permissions": "RUDS",
  "mimetype": "image/jpeg",
  "size": 8746526,
  "basename": "20260522_200132.jpg",
  "mtime": 1779472895,
  "owneruid": "rod",
  "filename": "/InstantUpload/Camera/20260522_200132.jpg"
}
```

Il campo `filename` non è presente nella risposta della timeline (`/days/{dayId}`) — serve sempre la chiamata a `/image/info`.

### Ottimizzazioni applicate
- `_dio` inizializzato come `late final` nel datasource (connection reuse, nessuna nuova connessione TCP per ogni chiamata)
- `_filename` cachato nel notifier dopo il primo load — `toggle` non rifà la chiamata di rete per ottenerlo
- `_ds` (datasource) istanziato una volta in `build` e riusato in `toggle`
- `ref.keepAlive()` nel provider — scorrendo tra foto e tornando indietro lo stato non viene ricostruito

## TODO
- [ ] Mostrare lo stato preferito iniziale anche nella griglia della timeline
- [ ] Aggiungere pulsante condivisione
- [ ] Aggiungere visualizzazione metadati (data, dimensioni, posizione GPS)
