# Ambiente di sviluppo

## Requisiti

- Flutter SDK (canale stable)
- JDK Temurin 21 (vedi sotto)
- Android SDK
- Device Android fisico o emulatore

## JDK

Usare **Temurin 21** installato via repo Adoptium (`/usr/lib/jvm/temurin-21-jdk`).

Il sistema potrebbe avere Java 25 headless (solo JRE, senza `javac`) — non va bene per Gradle. Temurin 21 è configurato esplicitamente in `android/gradle.properties`:

```properties
org.gradle.java.home=/usr/lib/jvm/temurin-21-jdk
```

## Avviare l'app

```bash
# Su device fisico (preferito per sviluppo)
flutter run -d <device-id>

# Elenco device connessi
flutter devices

# Su emulatore
flutter run -d emulator-5554
```

Lanciare sempre da terminale per avere **hot reload** disponibile (`r`).

## Code generation

Dopo ogni modifica a file con annotazioni Freezed, json_serializable o Riverpod:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Analisi statica

```bash
flutter analyze
```

Zero issue attesi. I warning `invalid_annotation_target` su file Freezed con `@JsonKey` sono soppressi con `// ignore_for_file: invalid_annotation_target` in cima al file.

## Struttura test

```
test/
└── features/
    ├── auth/
    └── profile/
```

## Warning noti (non bloccanti)

- `home_widget` e `photo_manager` usano ancora Kotlin Gradle Plugin diretto. Future versioni di Flutter richiederanno la migrazione a Built-in Kotlin. Monitorare i changelog dei plugin.
