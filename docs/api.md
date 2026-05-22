# API Nextcloud

## Autenticazione

Tutte le richieste usano **Basic Auth** con username e App Password Nextcloud.

```
Authorization: Basic base64(username:app_password)
OCS-APIRequest: true
```

Le credenziali vengono salvate in **Flutter Secure Storage** e iniettate tramite `AuthInterceptor` (`core/api/auth_interceptor.dart`).

---

## Nextcloud Memories API

Base URL: `https://{server}/apps/memories/api`

Gli endpoint sono definiti come costanti in `core/api/memories_api.dart`.

| Metodo | Path | Body | Descrizione |
|---|---|---|---|
| GET | `/days` | — | Lista giorni con conteggio foto |
| POST | `/days` | `{"dayIds": [...]}` | Foto di uno o più giorni (batch) |
| GET | `/clusters/albums` | — | Lista album |
| GET | `/clusters/albums/{albumId}` | — | Foto di un album |
| GET | `/image/info/{fileId}` | — | Metadati foto (path DAV, favorite, dimensioni) |
| GET | `/image/preview/{fileId}?c={etag}&x={w}&y={h}&a=1` | — | Thumbnail / preview foto |

### GET `/image/info/{fileId}`

Restituisce metadati completi della foto. Usato per ottenere il path WebDAV e lo stato preferito prima di un PROPPATCH.

Risposta attesa (struttura da verificare su istanza reale):
```json
{
  "fileid": 123456,
  "basename": "IMG_001.jpg",
  "filename": "/InstantUpload/Camera/IMG_001.jpg",
  "favorite": 0,
  "mimetype": "image/jpeg",
  "w": 4032,
  "h": 3024
}
```

> **TODO** — verificare i nomi esatti dei campi (`filename`, `favorite`) sulla risposta reale di `https://{server}/apps/memories/api/image/info/{fileId}`.

---

### PROPPATCH WebDAV — Preferiti

Imposta/rimuove il flag preferito su un file.

```
PROPPATCH /remote.php/dav/files/{username}/{path}
Content-Type: application/xml
```

```xml
<?xml version="1.0"?>
<d:propertyupdate xmlns:d="DAV:"
  xmlns:oc="http://owncloud.org/ns">
  <d:set>
    <d:prop>
      <oc:favorite>1</oc:favorite>
    </d:prop>
  </d:set>
</d:propertyupdate>
```

Risposta: `207 Multi-Status`. Usare `0` per rimuovere il preferito.

---

### GET `/image/preview/{fileId}`

Parametri query:
- `c` — etag del file (obbligatorio)
- `x` / `y` — dimensioni richieste in pixel (il server ritorna la dimensione più vicina)
- `a=1` — mantieni aspect ratio

Esempi: thumbnail griglia `x=512&y=512`, viewer fullscreen `x=1920&y=1080`.

Richiede autenticazione Basic Auth negli header.

---

### GET `/days`

Restituisce la lista completa dei giorni. I giorni più recenti possono includere già il campo `detail` con le foto precaricate.

```json
[
  {
    "dayid": 20233,
    "count": 6,
    "detail": [...]
  },
  {
    "dayid": 20232,
    "count": 74
  }
]
```

**Note:**
- `dayid` è in **giorni dall'Unix epoch** (non YYYYMMDD) — convertire con `DateTime.fromMillisecondsSinceEpoch(dayId * 86400 * 1000)`
- I `dayId` negativi sono validi (foto precedenti al 1970: scansioni, foto analogiche)
- `detail` è presente solo per alcuni giorni recenti — se disponibile evita la POST successiva

---

### POST `/days`

Fetch batch delle foto per uno o più giorni. È il metodo usato dalla web app di Memories.

**Payload:**
```json
{ "dayIds": [20233, 20232, 20231] }
```

**Risposta:** array piatto di foto (non wrappato in oggetti day)
```json
[
  {
    "fileid": 123456,
    "dayid": 20233,
    "basename": "IMG_20250525_001.jpg",
    "epoch": 1748200000,
    "mimetype": "image/jpeg",
    "w": 2048,
    "h": 1536,
    "etag": "abc123def456abc123def456abc12345",
    "auid": "abc123def456abc123def456abc12345"
  }
]
```

**Campi foto:**
| Campo | Tipo | Descrizione |
|---|---|---|
| `fileid` | int | ID univoco del file |
| `dayid` | int | Giorno Unix epoch di appartenenza |
| `basename` | string | Nome file |
| `epoch` | int | Timestamp Unix della foto (secondi) |
| `mimetype` | string | Tipo MIME (`image/jpeg`, `image/png`, ecc.) |
| `w` | int? | Larghezza in pixel |
| `h` | int? | Altezza in pixel |
| `etag` | string? | ETag per cache |
| `auid` | string? | ID univoco alternativo |

---

### GET `/clusters/albums`

```json
[
  {
    "album_id": 1,
    "name": "My Album",
    "user": "username",
    "created": 1700000000,
    "location": "",
    "last_added_photo": 123456,
    "count": 42,
    "shared": false,
    "cover": null,
    "last_added_photo_etag": "abc123def456abc123def456abc12345",
    "cluster_id": "username/My Album",
    "user_display": "Display Name",
    "cluster_type": "albums"
  }
]
```

**Note:**
- Album con `name` che inizia con `.link-` sono link condivisi, da filtrare nella UI
- `cluster_id` (formato `user/album_name`) è l'identificatore per richiedere le foto dell'album
- `cover` è spesso null — usare `last_added_photo` come fallback per la copertina

---

## OCS API (Nextcloud Core)

Base URL: `https://{server}/ocs/v2.php/cloud`

Usata per dati utente non legati a Memories.

| Metodo | Path | Descrizione |
|---|---|---|
| GET | `/users/{username}` | Info utente (nome, email, quota) |
| GET | `/capabilities` | Capabilities server (usato per validare connessione) |

### Esempio risposta `/users/{username}`

```json
{
  "ocs": {
    "meta": { "status": "ok", "statuscode": 200 },
    "data": {
      "id": "username",
      "display-name": "Nome Cognome",
      "email": "email@example.com",
      "quota": {
        "free": 5368709120,
        "used": 4831838208,
        "total": 10737418240,
        "relative": 45.0,
        "quota": 10737418240
      }
    }
  }
}
```

**Nota sul campo `quota.quota`**: vale `-3` quando lo spazio è illimitato. In questo caso `total` riflette lo spazio disco disponibile sul server, non un limite assegnato all'utente.

---

## WebDAV

Base URL: `https://{server}/remote.php/dav/files/{username}/`

Usato per download file e listing directory. Il client è `webdav_client`.

---

## Avatar

```
GET {server}/index.php/avatar/{username}/{size}
```

Restituisce un'immagine PNG. Richiede autenticazione Basic Auth tramite header. Dimensioni comuni: `64`, `128`, `256`.
