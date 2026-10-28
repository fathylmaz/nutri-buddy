# NutriBuddy — Stage 1 (Core Setup & Architecture)

This is an **overlay** for a Flutter-generated mobile project; not a standalone
replacement for Android/iOS platform scaffolding. Flutter 3.47+ / Dart 3.13+.

## Setup — PowerShell (Windows)

```powershell
flutter doctor -v
flutter create --org com.example --platforms android,ios nutri_buddy
cd nutri_buddy
# Extract nutri_buddy_step1_overlay.zip into THIS folder and overwrite duplicate files.
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format lib test
flutter analyze
flutter test
flutter run
```

If your Windows Flutter install does not support iOS generation, use:
`flutter create --org com.example --platforms android nutri_buddy`.
Use an emulator or connected Android device for `flutter run`.

## Supabase optional connection

The app opens without a Supabase project. To configure remote client startup,
copy `.env.example.json` to `.env.dev.json`, fill in the project URL and
**publishable** key, then run:

```powershell
flutter run --dart-define-from-file=.env.dev.json
```

Never put Supabase `service_role` keys or OpenAI API secrets into Flutter.
Build-time constants are extractable from distributed mobile apps.

## Build and quality gates

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

For continuous code generation during development:

```powershell
dart run build_runner watch --delete-conflicting-outputs
```

`*.g.dart` / `*.freezed.dart` are **generated**, and are intentionally not
shipped in the overlay. They must exist after code generation, before testing.
Commit the generated files and `pubspec.lock` once verified for repeatable CI.

## Architecture policy

- `domain`: pure business policy and interface contracts; no Flutter widgets,
  network clients, or Isar-specific types.
- `data`: local/remote data sources, DTOs, repository implementations and
  sync adapters. The business layer never imports from data.
- `presentation`: widgets and Riverpod providers; dependencies point inward.
- `core`: cross-cutting theme, bootstrap and configuration; no feature rules.
- Offline-first goal for later steps: local writes, durable pending-op outbox,
  explicit conflict strategy, idempotent replay, RLS and retry/backoff.
- Isar cannot be opened until the first real collection schema exists (Stage 2).
- Supabase tables, RLS rules, Isar collections, sync engine, authentication and
  health calculations are intentionally NOT implemented here.
- If the `rive_native` runtime complains about missing native libraries,
  see the Rive package setup instructions for the development platform.

## Definition of Done (Stage 1)

- `flutter pub get` resolves the dependencies.
- `build_runner build` creates `foundation_status.freezed.dart` and
  `foundation_provider.g.dart`.
- `flutter analyze` returns no errors.
- `flutter test` passes.
- An Android emulator/device displays the foundation page.
- User approval is received before Stage 2.

## Security and health-data notes

User health information is sensitive. Planned Supabase tables must use strict
RLS and user-scoped authorization. Photos will need consent, data retention and
safe deletion policies; LLM calls must flow through trusted server-side code.
Calories, vitamin content and dietary recommendations from AI are estimates,
not medical diagnoses or a substitute for clinical advice.

## Tooling version note (2026-10-22)

Pin `build_runner: 2.16.2` exactly (no caret). Version 2.17.1
requires `build` 5.x while Riverpod Generator 4.0.9 currently requires
`build` below 5. For this stage, keep the pinned version until the
generator ecosystem updates to a compatible set.
