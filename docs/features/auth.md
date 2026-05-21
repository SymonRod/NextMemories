# Feature: Auth

Gestisce il login, il salvataggio sicuro delle credenziali e la validazione della connessione al server Nextcloud.

## File

```
features/auth/
├── data/
│   ├── datasources/auth_local_datasource.dart   # Legge/scrive da Flutter Secure Storage
│   ├── models/server_config_model.dart           # DTO (Freezed + json_serializable)
│   └── repositories/auth_repository_impl.dart   # Implementazione IAuthRepository
├── domain/
│   ├── entities/server_config.dart              # Entity con serverUrl, username, appPassword
│   ├── repositories/i_auth_repository.dart      # Interfaccia repository
│   └── usecases/
│       ├── get_credentials_use_case.dart        # Legge credenziali salvate
│       ├── save_credentials_use_case.dart       # Salva credenziali
│       └── validate_connection_use_case.dart    # Valida connessione al server
└── presentation/
    ├── providers/auth_provider.dart             # AuthProvider (AsyncNotifier<ServerConfig?>)
    └── screens/login_screen.dart               # UI login
```

## Flusso

1. All'avvio, `authProvider` chiama `GetCredentialsUseCase` — se trova credenziali salvate, lo stato diventa `AsyncData(ServerConfig)` e il router reindirizza a `/timeline`.
2. Se nessuna credenziale, il router reindirizza a `/auth` (LoginScreen).
3. L'utente inserisce server URL, username e App Password.
4. `authProvider.login()` chiama `ValidateConnectionUseCase` che fa `GET /ocs/v2.php/cloud/capabilities`. Se 200, salva le credenziali e aggiorna lo stato.
5. Il router reagisce al cambio di stato e naviga a `/timeline`.

## Credenziali

Salvate in **Flutter Secure Storage** (keychain su iOS, EncryptedSharedPreferences su Android). Mai in Hive o SharedPreferences.

## Entity

```dart
ServerConfig {
  serverUrl: String    // es. "https://cloud.example.com"
  username: String
  appPassword: String  // App Password Nextcloud (non la password utente)
}
```

## Provider

```dart
// Leggere la config corrente
final config = ref.watch(authProvider).valueOrNull;

// Login
final error = await ref.read(authProvider.notifier).login(
  serverUrl: '...',
  username: '...',
  appPassword: '...',
);

// Logout
await ref.read(authProvider.notifier).logout();
```
