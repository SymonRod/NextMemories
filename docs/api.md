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

Base URL: `https://{server}/index.php/apps/memories/api/v1`

Gli endpoint sono definiti come costanti in `core/api/memories_api.dart`.

| Metodo | Path | Descrizione |
|---|---|---|
| GET | `/days` | Lista giorni con foto (timeline) |
| GET | `/days/{dayId}` | Foto di un giorno specifico |
| GET | `/albums` | Lista album |
| GET | `/albums/{albumId}` | Foto di un album |
| GET | `/photo/{fileId}/info` | Metadati foto |
| GET | `/photo/{fileId}/preview` | Thumbnail foto |

### Esempio risposta `/days`

```json
[
  {
    "dayid": 20240115,
    "count": 12
  }
]
```

### Esempio risposta `/days/{dayId}`

```json
[
  {
    "fileid": 123456,
    "basename": "IMG_0001.jpg",
    "datetime": "2024-01-15T10:30:00",
    "w": 4032,
    "h": 3024,
    "etag": "abc123"
  }
]
```

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
