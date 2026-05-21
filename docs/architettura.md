# Architettura

## Feature-First Clean Architecture (FFCA)

Ogni feature è un modulo autonomo con tre layer separati.

```
lib/
├── core/                        # Codice condiviso tra feature
│   ├── api/                     # Client HTTP, interceptors, endpoint constants
│   ├── error/                   # Failure classes
│   └── router/                  # GoRouter, route definitions
└── features/
    └── {feature}/
        ├── data/
        │   ├── datasources/     # Chiamate HTTP, accesso DB/storage
        │   ├── models/          # DTO con Freezed + json_serializable
        │   └── repositories/    # Implementazioni dei repository
        ├── domain/
        │   ├── entities/        # Modelli di dominio (Freezed, immutabili)
        │   ├── repositories/    # Interfacce repository (abstract interface)
        │   └── usecases/        # Use case (una responsabilità ciascuno)
        └── presentation/
            ├── providers/       # Riverpod providers (@riverpod annotation)
            └── screens/         # Widget, screen
```

### Regola delle dipendenze

```
presentation → domain ← data
```

- `presentation` dipende da `domain` (usa entity e chiama use case tramite provider)
- `data` dipende da `domain` (implementa le interfacce repository)
- `domain` non dipende da nessuno (puro Dart)

---

## Layer responsibilities

### domain/entities
Entity immutabili con Freezed. Nessuna logica di serializzazione, nessun riferimento a framework.

```dart
@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    required String id,
    required String displayName,
  }) = _UserInfo;
}
```

### domain/repositories
Interfacce che il layer `data` implementa. Restituiscono `Either<Failure, T>`.

```dart
abstract interface class IProfileRepository {
  Future<Either<Failure, UserInfo>> getUserInfo();
}
```

### domain/usecases
Una classe, un metodo `call()`. Non contengono logica complessa — orchestrano repository.

```dart
class GetUserInfoUseCase {
  Future<Either<Failure, UserInfo>> call() => _repository.getUserInfo();
}
```

### data/models
DTO con Freezed + `json_serializable`. Convertono in entity tramite metodo di mapping nel repository.

### data/repositories
Implementano le interfacce domain. Gestiscono eccezioni e le convertono in `Failure`.

### presentation/providers
Provider Riverpod generati con `@riverpod`. Chiamano use case e espongono `AsyncValue<T>` alla UI.

### presentation/screens
Solo UI. Nessuna logica di business. Leggono `AsyncValue` e lo gestiscono con `.when()`.

---

## Convenzioni

### Naming
| Tipo | Convenzione | Esempio |
|---|---|---|
| File | `snake_case.dart` | `user_info_model.dart` |
| Classe | `PascalCase` | `UserInfoModel` |
| Provider | suffisso `Provider` | `userInfoProvider` |
| Use case | verbo + sostantivo | `GetUserInfoUseCase` |
| Repository interface | prefisso `I` | `IProfileRepository` |

### Error handling
Usare `Either<Failure, T>` da `fpdart`. Mai `throw` nel layer domain/data.

```dart
// Corretto
return Left(NetworkFailure('Impossibile raggiungere il server'));

// Sbagliato
throw Exception('Impossibile raggiungere il server');
```

### Code generation
Dopo ogni modifica a model, entity o provider con annotation:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

File generati (`*.freezed.dart`, `*.g.dart`) non vanno mai modificati manualmente.
