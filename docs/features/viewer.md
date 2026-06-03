# Feature: Viewer

## Stato
Funzionante — visualizzazione fullscreen, navigazione, preferiti e metadati EXIF operativi.

## Descrizione
Visualizzatore foto fullscreen con zoom, swipe tra foto dello stesso giorno, toggle preferito e pannello metadati EXIF.

## Architettura

```
viewer/
├── data/
│   ├── datasources/
│   │   ├── favorite_remote_datasource.dart
│   │   └── photo_info_remote_datasource.dart
│   └── models/
│       └── photo_info_model.dart
└── presentation/
    ├── providers/
    │   ├── favorite_provider.dart
    │   └── photo_info_provider.dart
    └── screens/
    │   └── viewer_screen.dart
    └── widgets/
        ├── photo_page.dart
        └── photo_info_sheet.dart
```

## Navigazione

Rotta: `/viewer?dayId={dayId}&index={photoIndex}`

Aperto da `_PhotoTile` nella timeline screen via `context.push(...)`.

## Funzionalità implementate

- Visualizzazione fullscreen con sfondo nero
- `PageView` per swipe sinistra/destra tra le foto del giorno
- `InteractiveViewer` per pinch-to-zoom (max 5x)
- Tap per mostrare/nascondere AppBar e contatore
- AppBar con nome file, pulsante info (ⓘ) e pulsante stella (preferito)
- Immagine a risoluzione `1920x1920` con thumbnail 256px come placeholder istantaneo

---

## Preferiti

### Flusso
1. `GET /apps/memories/api/image/info/{fileId}` → ottiene `filename` (path WebDAV completo, es. `/InstantUpload/Camera/20260522_200132.jpg`). La risposta **non include** lo stato preferito.
2. `PROPFIND /remote.php/dav/files/{username}{filename}` con `Depth: 0` → legge la proprietà `oc:favorite` (valore `0` o `1`).
3. `PROPPATCH /remote.php/dav/files/{username}{filename}` con body XML `oc:favorite` → imposta/rimuove preferito.

### Ottimizzazioni applicate
- `_dio` inizializzato come `late final` nel datasource (connection reuse)
- `_filename` cachato nel notifier dopo il primo load — `toggle` non rifà la chiamata di rete
- `_ds` istanziato una volta in `build` e riusato in `toggle`
- `ref.keepAlive()` nel provider — stato preservato durante la navigazione

---

## Metadati EXIF (`photo_info_sheet.dart`)

Pannello a comparsa (`DraggableScrollableSheet`) aperto dal pulsante ⓘ in AppBar.

### Flusso
1. `GET /apps/memories/api/image/info/{fileId}` → `PhotoInfoModel` via `photo_info_provider`
2. Il provider usa `ref.keepAlive()`: la chiamata avviene solo al primo tap, poi i dati sono in cache per tutta la sessione del viewer.

### Struttura risposta `/image/info/{fileId}`

La risposta reale differisce dalla documentazione ufficiale su alcuni punti critici:

```json
{
  "fileid": 1062112,
  "dayid": 20606,
  "w": 4000,
  "h": 3000,
  "datetaken": 1780409147,
  "exif": {
    "Make": "samsung",
    "Model": "Galaxy S25 Ultra",
    "ExposureTime": 0.000419416,
    "FNumber": 1.7,
    "ISO": 40,
    "FocalLength": 6.3,
    "WhiteBalance": 0,
    "MeteringMode": 2,
    "Flash": 16,
    "DateTimeOriginal": "2026:06:02 14:05:47",
    "GPSLatitude": 45.593994,
    "GPSLongitude": 7.3967925,
    "GPSAltitude": 1681
  },
  "size": 12065887,
  "basename": "20260602_140547.jpg",
  "filename": "/InstantUpload/Camera/20260602_140547.jpg",
  "tags": { "10": "Nature", "13": "Alpine" }
}
```

**Differenze rispetto alla doc API:**
| Campo | Doc ufficiale | Risposta reale |
|-------|--------------|----------------|
| Larghezza | `width` | `w` |
| Altezza | `height` | `h` |
| Data scatto | `dateTaken` | `datetaken` |
| ISO | `ISOSpeedRatings` (int) | `ISO` (int) |
| Apertura | `FNumber` (stringa `"16/10"`) | `FNumber` (double `1.7`) |
| Tempo posa | `ExposureTime` (stringa `"1/120"`) | `ExposureTime` (double `0.000419416`) |
| Focale | `FocalLength` (stringa `"52/10"`) | `FocalLength` (double `6.3`) |
| GPS | `GpsLatitude` (stringa) | `GPSLatitude` (double) |
| Tags | array | oggetto `{"id": "nome"}` |

### Sezioni del pannello
| Sezione | Campi mostrati |
|---------|---------------|
| File | Nome, percorso, dimensione, risoluzione, data scatto |
| Descrizione | `ImageDescription` (se presente) |
| Camera | Produttore, Modello, Software |
| Impostazioni scatto | Apertura, Tempo di posa, ISO, Focale, Comp. esposizione, Modalità misurazione, Flash, Bilanciamento bianco |
| Posizione GPS | Latitudine, Longitudine, Altitudine |

### Formattazione valori
- **Tempo di posa**: se < 1s → `1/X s` (es. `1/2384 s`); se ≥ 1s → `X.X s`
- **Apertura / Focale**: double formattato senza decimali superflui (es. `1.7`, `6`)
- **GPS**: 6 decimali per lat/lon; altitudine arrotondata al metro
- **MeteringMode**: decodificato da intero EXIF (0=Unknown, 1=Media, 2=Media centrale, 3=Spot, 4=Multi-spot, 5=Matrix, 6=Parziale)
- **Flash**: bit 0 del valore EXIF determina se attivato o meno

---

## TODO
- [ ] Mostrare lo stato preferito iniziale anche nella griglia della timeline
- [ ] Aggiungere pulsante condivisione
- [ ] Mappa interattiva nel pannello GPS
