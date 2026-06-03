# Memories API - Documentazione Completa

**Base URL**: `https://{server}/apps/memories/api`

**Autenticazione**: Basic Auth o App Password Nextcloud (vedi [Autenticazione](#autenticazione))

---

## Autenticazione

### Basic Authentication
- **Meccanismo**: Invia un header `Authorization` con schema `Basic` seguito da Base64 di `username:password`
- **Header**: `Authorization: Basic <Base64(username:password)>`
- **Esempio**: 
  ```
  Authorization: Basic YWRtaW46cGFzc3dvcmQxMjM=
  ```

### App Password (Consigliato)
Utilizza le App Password di Nextcloud per maggiore sicurezza (non esponendo la password reale):
1. Vai in Nextcloud: Settings → Personal → Security
2. Genera una "App Password" (es. "Memories Mobile")
3. Usa quella nel header Authorization

### Endpoint Pubblici
Alcuni endpoint sono accessibili anche **senza autenticazione**:
- `GET /api/days` (per public shares)
- `GET /api/days/{id}` (per public shares)
- `GET /api/image/preview/{id}` (per public shares)
- Tutti gli endpoint in `/api/image/`, `/api/video/` per foto pubbliche

---

## Timeline API

### GET /api/days
Ottiene la lista di giorni con foto disponibili (raggruppate per data).

#### Parametri Query
| Parametro | Tipo | Default | Descrizione |
|-----------|------|---------|-------------|
| `recursive` | boolean | `true` | Se `1`, cerca ricorsivamente in tutte le sottocartelle. Se non presente, cerca solo nella cartella impostata |
| `folder` | string | - | Limita la ricerca a una cartella specifica. Se omesso, usa la cartella configurata |
| `archive` | boolean | `false` | Se presente (qualsiasi valore), include le foto archiviate |
| `hidden` | boolean | `false` | Se presente, include file nascosti |
| `monthView` | boolean | `false` | Se presente, raggruppa per mese invece che per giorno |
| `reverse` | boolean | `false` | Se presente, ordina dal più recente al più vecchio |
| `fav` | boolean | `false` | Se presente, mostra solo foto preferite (requires auth) |
| `vid` | boolean | `false` | Se presente, mostra solo video (requires auth) |
| `mapbounds` | string | - | Filtro geografico nel formato `minlon,minlat,maxlon,maxlat` (requires auth) |
| `limit` | int | - | Limita il numero di risultati per giorno |
| `nopreload` | boolean | `false` | Se presente, disabilita il preload delle foto per ottimizzare la velocità |

#### Esempio Request
```bash
GET /api/days?recursive=1&fav=1&monthView=1 HTTP/1.1
Authorization: Basic <credentials>
```

#### Esempio Response (200 OK)
```json
[
  {
    "dayid": 1629312000,
    "count": 42,
    "detail": [
      {
        "fileid": 12345,
        "dayid": 1629312000,
        "basename": "photo_001.jpg",
        "w": 3024,
        "h": 4032,
        "datetaken": 1629312000000
      },
      {
        "fileid": 12346,
        "dayid": 1629312000,
        "basename": "photo_002.jpg",
        "w": 4032,
        "h": 3024,
        "datetaken": 1629312005000
      }
    ]
  },
  {
    "dayid": 1629398400,
    "count": 15
  }
]
```

#### Codici Errore
| Codice | Descrizione |
|--------|-------------|
| 200 | OK - Lista giorni restituita con successo |
| 401 | Unauthorized - Credenziali non valide o scadute |
| 403 | Forbidden - Accesso alla cartella negato |
| 500 | Internal Server Error - Errore nel server |

---

### GET /api/days/{id} (o POST /api/days)
Ottiene le foto di uno o più giorni specifici.

#### GET Variant: /api/days/{id}
- **Path Parameter**: `id` - ID del giorno (timestamp) o ID multipli separati da virgola (es: `1629312000,1629398400`)
- Internamente richiama lo stesso handler di POST

#### POST Variant: /api/days
Accetta un array di `dayIds` nel body JSON.

#### Parametri Query (uguali a GET /api/days)
Valgono gli stessi parametri di `GET /api/days`:
- `recursive`, `folder`, `archive`, `hidden`, `monthView`, `reverse`
- `fav`, `vid`, `mapbounds`, `limit`, `nopreload`

#### POST Request Body
```json
{
  "dayIds": [1629312000, 1629398400]
}
```

#### Esempio Request
```bash
GET /api/days/1629312000,1629398400?fav=1 HTTP/1.1
Authorization: Basic <credentials>
```

#### Esempio Response (200 OK)
```json
[
  {
    "fileid": 12345,
    "dayid": 1629312000,
    "basename": "photo_001.jpg",
    "w": 3024,
    "h": 4032,
    "datetaken": 1629312000000,
    "isvideo": 0,
    "isfav": 1,
    "permissions": "RGDNVCK"
  },
  {
    "fileid": 12346,
    "dayid": 1629312000,
    "basename": "photo_002.jpg",
    "w": 4032,
    "h": 3024,
    "datetaken": 1629312005000,
    "isvideo": 0,
    "isfav": 0,
    "permissions": "RGDNVCK"
  }
]
```

#### Struttura Foto
| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `fileid` | int | ID file unico nel server Nextcloud |
| `dayid` | int | Timestamp del giorno (secondi da epoch) |
| `basename` | string | Nome del file |
| `w` | int | Larghezza immagine in pixel |
| `h` | int | Altezza immagine in pixel |
| `datetaken` | int | Timestamp della foto (millisecondi da epoch) |
| `isvideo` | 0\|1 | 1 se è video, 0 se è foto |
| `isfav` | 0\|1 | 1 se è segnata come preferita |
| `permissions` | string | Codice permessi Nextcloud (vedi sotto) |

#### Permessi
Formato stringa con lettere: `RGDNVCK` significa:
- `R`: Lettura (Read)
- `G`: Condivisione (sharinG)
- `D`: Cancellazione (Delete)
- `N`: Creazione (creatioN)
- `V`: Rinominazione (moVe)
- `C`: Cambio (Change/Edit)
- `K`: nessun download (no downloads - se presente)

---

## Image/Photo API

### GET /api/image/preview/{id}
Genera o recupera un'anteprima (thumbnail) di un'immagine.

#### Path Parameter
- `id` (int, required): File ID della foto

#### Query Parameters
| Parametro | Tipo | Default | Descrizione |
|-----------|------|---------|-------------|
| `x` | int | 32 | Larghezza anteprima desiderata (pixels) |
| `y` | int | 32 | Altezza anteprima desiderata (pixels) |
| `a` | bool | false | Se `1`, mantiene il aspect ratio senza ritagli |
| `mode` | string | "fill" | Modalità: `fill` (riempimento) o `cover` (copertura) |

#### Esempio Request
```bash
GET /api/image/preview/12345?x=256&y=256&a=1 HTTP/1.1
Authorization: Basic <credentials>
```

#### Response (200 OK)
- **Content-Type**: `image/jpeg` (o `image/png`, `image/webp` a seconda del formato)
- **Body**: Binary image data
- **Cache**: Cacheable per 24 ore (header `Cache-Control: max-age=86400`)

#### Codici Errore
| Codice | Descrizione |
|--------|-------------|
| 200 | OK - Anteprima restituita |
| 400 | Bad Request - Parametri non validi (x=0 o y=0) |
| 401 | Unauthorized |
| 404 | Not Found - File non esiste |
| 500 | Generatore anteprima non trovato |

---

### POST /api/image/multipreview
Scarica anteprime di **più immagini in un'unica richiesta** (ottimizzato per bulk).

**⚠️ Nota**: Risposta binaria complessa con framing personalizzato (non JSON standard).

#### Request Body
```json
{
  "files": [
    {
      "reqid": "req1",
      "fileid": 12345,
      "x": 256,
      "y": 256,
      "a": "0"
    },
    {
      "reqid": "req2",
      "fileid": 12346,
      "x": 512,
      "y": 512,
      "a": "1"
    }
  ]
}
```

#### Response (200 OK)
- **Content-Type**: `application/octet-stream`
- **Formato**: Stream binario con frame per ogni immagine
- Ogni frame contiene:
  1. **1 byte**: Lunghezza JSON metadata
  2. **JSON**: `{"reqid": "req1", "len": 45632, "type": "image/jpeg"}`
  3. **Binary**: Dati immagine (numero di byte indicato da `len`)

#### Codici Errore
| Codice | Descrizione |
|--------|-------------|
| 200 | OK - Stream anteprime restituito |
| 400 | Bad Request - Parametri file non validi |
| 401 | Unauthorized |
| 404 | File non trovato |

---

### GET /api/image/info/{id}
Recupera i metadati EXIF e informazioni complete di una foto.

#### Path Parameter
- `id` (int, required): File ID

#### Query Parameters
| Parametro | Tipo | Default | Descrizione |
|-----------|------|---------|-------------|
| `basic` | bool | false | Se `1`, restituisce solo info base (più veloce) |
| `current` | bool | false | Se `1`, include timestamp corrente |
| `tags` | bool | false | Se `1`, include tag del sistema (requires auth) |
| `clusters` | string | "" | Comma-separated lista di backend di clustering (es: `recognize,facerecognition`) |

#### Esempio Request
```bash
GET /api/image/info/12345?tags=1&clusters=recognize,facerecognition HTTP/1.1
Authorization: Basic <credentials>
```

#### Esempio Response (200 OK)
```json
{
  "fileid": 12345,
  "etag": "abc123def456",
  "permissions": "RGDNVCK",
  "mimetype": "image/jpeg",
  "size": 2456789,
  "basename": "photo_001.jpg",
  "mtime": 1629312000,
  "owneruid": "admin",
  "ownername": "Administrator",
  "filename": "/Photos/Vacation/photo_001.jpg",
  "width": 3024,
  "height": 4032,
  "dateTaken": 1629312000,
  "exif": {
    "ImageDescription": "Beach sunset",
    "Make": "Apple",
    "Model": "iPhone 12 Pro",
    "Orientation": 1,
    "XResolution": "72/1",
    "YResolution": "72/1",
    "Software": "iOS 15.0",
    "DateTime": "2021:08:18 14:00:00",
    "DateTimeOriginal": "2021:08:18 14:00:00",
    "DateTimeDigitized": "2021:08:18 14:00:00",
    "ExposureTime": "1/120",
    "FNumber": "16/10",
    "ISOSpeedRatings": 100,
    "ShutterSpeedValue": "69/8",
    "ApertureValue": "27/8",
    "BrightnessValue": "116/32",
    "ExposureBiasValue": "0/1",
    "MaxAperture": "27/8",
    "MeteringMode": 1,
    "Flash": 16,
    "FocalLength": "52/10",
    "ColorSpace": 1,
    "FocalPlaneXResolution": "1200",
    "FocalPlaneYResolution": "1200",
    "FocalPlaneResolutionUnit": 2,
    "GpsLatitude": "40.7128",
    "GpsLongitude": "-74.0060",
    "GpsAltitude": "10"
  },
  "imageinfo": {
    "width": 3024,
    "height": 4032
  },
  "tags": ["vacation", "beach"],
  "recognize": [
    {
      "name": "person",
      "score": 0.95
    },
    {
      "name": "outdoor",
      "score": 0.87
    }
  ]
}
```

#### Campi Risposta Principali
| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `fileid` | int | ID file |
| `basename` | string | Nome file |
| `size` | int | Dimensione in bytes |
| `mtime` | int | Timestamp modifica |
| `width` | int | Larghezza pixel |
| `height` | int | Altezza pixel |
| `dateTaken` | int | Timestamp foto (da EXIF) |
| `exif` | object | Dati EXIF completi |
| `permissions` | string | Codice permessi |
| `tags` | array | Tag di sistema (se richiesti) |
| `recognize` | array | Clustering da AI (se richiesto) |

---

### GET /api/image/decodable/{id}
Verifica se un'immagine è decodabile (formato valido).

#### Path Parameter
- `id` (int, required): File ID

#### Response (200 OK)
```json
{
  "decodable": true
}
```

#### Codici Errore
| Codice | Descrizione |
|--------|-------------|
| 200 | OK - Stato decodabilità restituito |
| 404 | File non trovato |

---

### PATCH /api/image/set-exif/{id}
Aggiorna i metadati EXIF di un'immagine (es. data scatto, posizione).

#### Path Parameter
- `id` (int, required): File ID

#### Request Body
```json
{
  "exif": {
    "DateTimeOriginal": "2021:08:18 14:00:00",
    "Make": "Canon",
    "Model": "EOS 5D Mark IV",
    "GpsLatitude": "40.7128",
    "GpsLongitude": "-74.0060"
  }
}
```

#### Response (200 OK)
```json
{
  "message": "ok"
}
```

#### Codici Errore
| Codice | Descrizione |
|--------|-------------|
| 200 | OK - EXIF aggiornato |
| 400 | Bad Request - Dati EXIF non validi |
| 401 | Unauthorized |
| 403 | Forbidden - Non hai permessi di modifica |
| 404 | File non trovato |

---

### DELETE /api/image/delete/{id}
Elimina il file fisico di un'immagine.

#### Path Parameter
- `id` (int, required): File ID

#### Response (204 No Content)
Nessun body nella risposta.

#### Codici Errore
| Codice | Descrizione |
|--------|-------------|
| 204 | No Content - File eliminato |
| 401 | Unauthorized |
| 403 | Forbidden - Non hai permessi di eliminazione |
| 404 | File non trovato |

---

## Video API

### GET /api/video/transcode/{client}/{fileid}/{profile}
Avvia la transcodifica di un video in HLS per lo streaming.

**⚠️ Nota**: Richiede che `go-vod` sia configurato e in esecuzione sul server.

#### Path Parameters
| Parametro | Tipo | Descrizione |
|-----------|------|-------------|
| `client` | string | Identificativo client (min 8 caratteri). Usato per caching |
| `fileid` | int | ID del file video |
| `profile` | string | Profilo transcodifica: `lq` (bassa qualità), `mq` (media), `hq` (alta) |

#### Esempio Request
```bash
GET /api/video/transcode/mobile_app_123456/67890/mq HTTP/1.1
Authorization: Basic <credentials>
```

#### Response (200 OK)
- **Content-Type**: `application/vnd.apple.mpegurl` (HLS playlist)
- **Body**: Playlist M3U8 con reference ai segmenti video
```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:10
#EXTINF:10.0,
segment0.ts
#EXTINF:10.0,
segment1.ts
#EXT-X-ENDLIST
```

#### Codici Errore
| Codice | Descrizione |
|--------|-------------|
| 200 | OK - Playlist HLS restituita |
| 400 | Bad Request - Client ID troppo corto |
| 401 | Unauthorized |
| 403 | Forbidden - Storage esterno non supportato |
| 404 | File non trovato |
| 501 | Transcoding disabilitato |

---

### GET /api/video/livephoto/{fileid}
Recupera la versione "live photo" di un video (foto + video).

#### Path Parameter
- `fileid` (int, required): File ID del video

#### Response
- **Content-Type**: Dipende dal formato (video/mp4, image/jpeg, ecc.)

---

## Download API

### POST /api/download
Richiede il download di uno o più file (crea una sessione temporanea).

#### Request Body
```json
{
  "files": [12345, 12346, 12347]
}
```

#### Response (200 OK)
```json
{
  "handle": "abc123def456xyz789"
}
```

#### Codici Errore
| Codice | Descrizione |
|--------|-------------|
| 200 | OK - Handle generato |
| 400 | Bad Request - Array file non valido |
| 401 | Unauthorized |

---

### GET /api/download/{handle}
Scarica il file (o ZIP di file multipli) usando l'handle generato da POST /api/download.

#### Path Parameter
- `handle` (string, required): Handle restituito da POST /api/download

#### Response (200 OK)
- **Single file**: Binary file data (Content-Type: tipo file originale)
- **Multiple files**: ZIP archive (Content-Type: application/zip, Filename: `memories-YYYYMMDDHHmmss.zip`)

#### Codici Errore
| Codice | Descrizione |
|--------|-------------|
| 200 | OK - File/ZIP restituito |
| 404 | Handle non trovato o scaduto |

**Nota**: L'handle scade dopo 1 richiesta GET (a meno che sia HEAD request).

---

### GET /api/stream/{fileid}
Scarica un singolo file per ID (alternativa senza sessione).

#### Path Parameter
- `fileid` (int, required): File ID

#### Query Parameters
| Parametro | Tipo | Descrizione |
|-----------|------|-------------|
| `Range` | header | HTTP Range header (es: `bytes=0-1023`) per download riprendibili |

#### Response (200 OK o 206 Partial Content)
- **Content**: Binary file data
- **Supporta**: HTTP Range requests per resume

#### Codici Errore
| Codice | Descrizione |
|--------|-------------|
| 200 | OK - Download completo |
| 206 | Partial Content - Range request |
| 401 | Unauthorized |
| 404 | File non trovato |

---

## Clustering & AI API

### GET /api/clusters/{backend}
Ottiene i cluster per un backend specifico (es. volti riconosciuti, etichette AI).

#### Path Parameter
- `backend` (string): Backend di clustering
  - `recognize`: Riconoscimento oggetti (dall'app Recognize)
  - `facerecognition`: Riconoscimento volti (dall'app Face Recognition)
  - `places`: Locations (dall'app Places)

#### Query Parameters
| Parametro | Tipo | Descrizione |
|-----------|------|-------------|
| `recursive` | bool | Cerca ricorsivamente |
| `archive` | bool | Includi foto archiviate |

#### Esempio Request
```bash
GET /api/clusters/recognize?recursive=1 HTTP/1.1
Authorization: Basic <credentials>
```

#### Response (200 OK)
```json
[
  {
    "id": "cat",
    "name": "Cat",
    "count": 42
  },
  {
    "id": "dog",
    "name": "Dog",
    "count": 18
  }
]
```

---

### GET /api/clusters/{backend}/preview
Ottiene un'anteprima (foto rappresentativa) di un cluster.

#### Path Parameters
- `backend` (string): Backend di clustering
- `cluster_id` (string): ID del cluster (da ottenere da GET /api/clusters/{backend})

#### Query Parameters
| Parametro | Tipo | Descrizione |
|-----------|------|-------------|
| `x` | int | Larghezza anteprima |
| `y` | int | Altezza anteprima |
| `cover` | int | ID foto da usare come cover |

#### Response (200 OK)
- Binary image data (foto rappresentativa)

---

## Tags & Archive API

### PATCH /api/tags/set/{id}
Aggiunge o rimuove un tag di sistema a una foto.

#### Path Parameter
- `id` (int, required): File ID

#### Request Body
```json
{
  "tags": [123, 456]
}
```

#### Response (200 OK)
```json
{
  "message": "ok"
}
```

---

### PATCH /api/archive/{id}
Marca una foto come archiviata (nascosta dalla timeline).

#### Path Parameter
- `id` (int, required): File ID

#### Request Body (vuoto)
```json
{}
```

#### Response (200 OK)
```json
{
  "message": "ok"
}
```

---

## Map API

### GET /api/map/init
Inizializza i dati della mappa (limiti geografici, centro iniziale).

#### Response (200 OK)
```json
{
  "bounds": {
    "minLat": -90,
    "maxLat": 90,
    "minLon": -180,
    "maxLon": 180
  },
  "center": {
    "lat": 51.5074,
    "lon": -0.1278
  },
  "zoom": 2
}
```

---

### GET /api/map/clusters
Ottiene i cluster geografici per la visualizzazione mappa.

#### Query Parameters
| Parametro | Tipo | Descrizione |
|-----------|------|-------------|
| `gridLen` | int | Granularità della griglia (numero di celle) |
| `bounds` | string | Limiti mappa nel formato `minlon,minlat,maxlon,maxlat` |

#### Response (200 OK)
```json
[
  {
    "center": {
      "lat": 40.7128,
      "lon": -74.0060
    },
    "count": 42,
    "clusterRadius": 50000
  }
]
```

---

## Share API

### GET /api/share/links
Ottiene tutti i link di condivisione (pubblica) di una foto o cartella.

#### Query Parameters
| Parametro | Tipo | Descrizione |
|-----------|------|-------------|
| `id` | int | File ID |
| `path` | string | Path del file (alternativa a `id`) |

#### Response (200 OK)
```json
[
  {
    "id": "share_123",
    "label": "Family Album",
    "token": "abc123def456",
    "url": "https://server.com/apps/memories/s/abc123def456",
    "hasPassword": false,
    "expiration": 1704067200,
    "editable": 1
  }
]
```

---

### POST /api/share/node
Crea un nuovo link di condivisione pubblica.

#### Request Body
```json
{
  "id": 12345,
  "label": "Shared Moment",
  "password": "secret123",
  "expirationDate": "2024-12-31"
}
```

#### Response (201 Created)
```json
{
  "id": "share_124",
  "label": "Shared Moment",
  "token": "xyz789abc123",
  "url": "https://server.com/apps/memories/s/xyz789abc123",
  "hasPassword": true,
  "expiration": 1704067200,
  "editable": 1
}
```

---

### POST /api/share/delete
Elimina un link di condivisione.

#### Request Body
```json
{
  "id": "share_123"
}
```

#### Response (200 OK)
```json
{
  "message": "ok"
}
```

---

## Configuration API

### GET /api/config
Ottiene tutte le impostazioni dell'utente corrente.

#### Response (200 OK)
```json
{
  "foldersPath": "/Photos",
  "showArchived": false,
  "sortByDate": true,
  "layoutMode": "timeline",
  "theme": "light",
  "monthView": false
}
```

---

### PUT /api/config/{key}
Aggiorna un'impostazione specifica dell'utente.

#### Path Parameter
- `key` (string): Chiave dell'impostazione (es. `foldersPath`, `theme`)

#### Request Body
```json
{
  "value": "/NewFolder"
}
```

#### Response (200 OK)
```json
{
  "message": "ok"
}
```

---

## Admin API

### GET /api/system-status
Ottiene lo stato del sistema (richiede accesso admin).

#### Response (200 OK)
```json
{
  "status": "ok",
  "version": "1.2.3",
  "indexedCount": 12450,
  "totalCount": 12500,
  "indexingInProgress": false
}
```

---

### GET /api/system-config
Ottiene la configurazione di sistema (richiede accesso admin).

#### Response (200 OK)
```json
{
  "memories.vod.disable": false,
  "memories.vod.quality": "medium",
  "memories.places.enabled": true,
  "memories.recognize.enabled": true
}
```

---

### PUT /api/system-config/{key}
Aggiorna una configurazione di sistema (richiede accesso admin).

#### Path Parameter
- `key` (string): Chiave della configurazione

#### Request Body
```json
{
  "value": true
}
```

#### Response (200 OK)
```json
{
  "message": "ok"
}
```

---

## Utility API

### GET /api/describe
**Endpoint auto-documentante**: Restituisce una descrizione di tutti gli endpoint API disponibili.

#### Response (200 OK)
```json
{
  "version": "1.2.3",
  "endpoints": {
    "GET /api/days": {
      "description": "Get list of days",
      "parameters": [...],
      "response": {...}
    }
  }
}
```

---

## Folders API

### GET /api/folders/sub
Ottiene la lista di sottocartelle.

#### Query Parameters
| Parametro | Tipo | Descrizione |
|-----------|------|-------------|
| `folder` | string | Cartella padre di cui elencare le sottocartelle |

#### Response (200 OK)
```json
[
  {
    "id": 99,
    "path": "/Photos",
    "name": "Photos"
  },
  {
    "id": 100,
    "path": "/Photos/Vacation",
    "name": "Vacation"
  }
]
```

---

## Error Handling

### Formato Errore Generico
```json
{
  "error": "File not found",
  "status": 404
}
```

### Codici HTTP Comuni
| Codice | Significato |
|--------|-------------|
| 200 | OK - Richiesta riuscita |
| 201 | Created - Risorsa creata |
| 204 | No Content - Successo, nessun contenuto |
| 206 | Partial Content - Range request soddisfatto |
| 400 | Bad Request - Parametri non validi |
| 401 | Unauthorized - Autenticazione richiesta |
| 403 | Forbidden - Accesso negato |
| 404 | Not Found - Risorsa non trovata |
| 500 | Internal Server Error - Errore server |

---

## Best Practices per NextMemories Flutter

### 1. Timeline Sync Offline
```
1. GET /api/days?recursive=1 → elenco giorni
2. GET /api/days/{id}?limit=20 → foto di un giorno
3. GET /api/image/preview/{id}?x=256&y=256 → thumbnail per cache
4. GET /api/stream/{id} → scarica foto completa per offline
```

### 2. Performance
- Usa `nopreload=1` se non hai bisogno di anteprime immediate
- Utilizza `/api/image/multipreview` per scaricare batch di thumbnail
- Implementa pagination con `limit` query parameter
- Cache aggressivo su preview (scadenza 24h)

### 3. Autenticazione Sicura
- Memorizza App Password in **Flutter Secure Storage**, non in Hive
- Non loggare credenziali nei log
- Rinnova token se ricevi 401 Unauthorized

### 4. Gestione Errori
- Retry automatico per 503 Service Unavailable
- Timeout ragionevole: 30s per preview, 60s per download completo
- Fallback offline se connessione cade durante sync

### 5. Query Parameters Comuni
```dart
// Timeline caricamento
/api/days?recursive=1&nopreload=1

// Foto specifico giorno
/api/days/1629312000?limit=50

// Anteprima di qualità
/api/image/preview/{id}?x=512&y=512&a=1

// Foto completo per download
/api/stream/{id}
```

---

## Esempio Flow Completo (Flutter)

```dart
// 1. Inizializzazione
const baseUrl = "https://nextcloud.example.com/apps/memories/api";
final headers = {
  'Authorization': 'Basic ' + base64Encode(utf8.encode('user:appPassword'))
};

// 2. Carica timeline
final response = await http.get(
  Uri.parse('$baseUrl/days?recursive=1&nopreload=1'),
  headers: headers,
);
List<Day> days = jsonDecode(response.body);

// 3. Carica foto di un giorno
final dayPhotos = await http.get(
  Uri.parse('$baseUrl/days/${days[0]['dayid']}'),
  headers: headers,
);
List<Photo> photos = jsonDecode(dayPhotos.body);

// 4. Scarica thumbnail
final thumbUrl = '$baseUrl/image/preview/${photos[0]['fileid']}?x=256&y=256';
final thumbData = await http.readBytes(Uri.parse(thumbUrl), headers: headers);

// 5. Scarica foto completo (offline)
final photoUrl = '$baseUrl/stream/${photos[0]['fileid']}';
final photoData = await http.readBytes(Uri.parse(photoUrl), headers: headers);
```
