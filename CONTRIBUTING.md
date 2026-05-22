# Contributing

Grazie per l'interesse nel progetto! Ecco come contribuire.

## Prerequisiti

- Flutter SDK (canale stable)
- JDK Temurin 21
- Un server Nextcloud con l'app [Memories](https://memories.gallery) installata per testare

Setup completo in [`docs/sviluppo.md`](docs/sviluppo.md).

## Workflow

1. Fai fork del repository
2. Crea un branch dal nome descrittivo: `feature/timeline-grid`, `fix/avatar-loading`, `docs/album-feature`
3. Fai le modifiche (vedi convenzioni sotto)
4. Apri una Pull Request verso `main`

## Prima di aprire una PR

```bash
# Verifica che il codice compili senza errori
flutter analyze

# Se hai modificato model, entity o provider con annotation
flutter pub run build_runner build --delete-conflicting-outputs

# Avvia l'app e verifica manualmente le modifiche
flutter run
```

## Convenzioni

L'architettura e le convenzioni del progetto sono documentate in [`docs/architettura.md`](docs/architettura.md). In breve:

- **Feature-First Clean Architecture**: ogni feature ha `data/`, `domain/`, `presentation/`
- **State management**: Riverpod con `@riverpod` annotation — niente `setState` o `ChangeNotifier`
- **Navigazione**: GoRouter — niente `Navigator.push` diretto
- **Error handling**: `Either<Failure, T>` nei repository — niente `throw` nel layer domain/data
- **Modelli**: Freezed per entity e DTO, `json_serializable` per JSON
- **Commenti**: in inglese nel codice; documentazione di progetto in italiano

## Nuove feature

Quando aggiungi una feature:

1. Crea tutte e tre le cartelle: `data/`, `domain/`, `presentation/`
2. Aggiungi la route in `core/router/app_router.dart`
3. Crea `docs/features/{nome-feature}.md` (vedi gli esistenti come riferimento)
4. Non modificare file generati (`*.freezed.dart`, `*.g.dart`)

## Segnalare bug

Apri una issue descrivendo:
- Cosa hai fatto
- Cosa ti aspettavi
- Cosa è successo invece
- Versione Android/iOS e versione Nextcloud Memories
