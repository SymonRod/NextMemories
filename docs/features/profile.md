# Feature: Profile

Mostra il profilo dell'utente Nextcloud: avatar, nome, username, server, quota storage. Contiene il bottone di logout. È il posto designato per le impostazioni future.

## File

```
features/profile/
├── data/
│   ├── datasources/profile_remote_datasource.dart  # GET /ocs/v2.php/cloud/users/{username}
│   ├── models/user_info_model.dart                 # DTO (Freezed + json_serializable)
│   └── repositories/profile_repository_impl.dart  # Implementazione IProfileRepository
├── domain/
│   ├── entities/user_info.dart                     # UserInfo + QuotaInfo (Freezed)
│   ├── repositories/i_profile_repository.dart      # Interfaccia repository
│   └── usecases/get_user_info_use_case.dart        # Recupera info utente
└── presentation/
    ├── providers/profile_provider.dart             # userInfoProvider (FutureProvider<UserInfo>)
    └── screens/profile_screen.dart                # UI profilo
```

## Entity

```dart
UserInfo {
  id: String           // username Nextcloud
  displayName: String  // nome visualizzato
  email: String?       // email (nullable)
  quota: QuotaInfo
}

QuotaInfo {
  used: int            // bytes utilizzati
  total: int           // bytes totali (irrilevante se unlimited)
  relative: double     // percentuale utilizzo (0-100)
  unlimited: bool      // true se quota.quota == -3
}
```

`QuotaInfo` espone anche `progressValue` (double 0.0-1.0) per la `LinearProgressIndicator`.

## API usata

```
GET {server}/ocs/v2.php/cloud/users/{username}?format=json
```

La risposta viene estratta da `response.data['ocs']['data']` e deserializzata in `UserInfoModel`.

## Avatar

```
GET {server}/index.php/avatar/{username}/256
```

Caricato con `CachedNetworkImage` passando l'header `Authorization: Basic ...` per l'autenticazione.

## Navigazione

Raggiungibile dal tab "Profilo" (terzo tab) della bottom navigation bar.
Route: `/profile`

## Aggiungere impostazioni future

La `ProfileScreen` usa una `ListView`. Per aggiungere una sezione impostazioni, inserire un nuovo widget dopo `_QuotaCard` e prima del bottone logout.
