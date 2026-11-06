---
name: flutter-upgrade
description: Upgrading a Flutter app to a newer Flutter SDK, or fixing what broke after one. Use when the user says they upgraded or want to upgrade Flutter (flutter upgrade, new stable, 3.44, 3.47, ...), when code or builds broke after an SDK, Xcode, Android Gradle Plugin (AGP 9) or Kotlin bump, or when asked to fix deprecations after an upgrade — Dart errors like a removed API or a class that is now final, Android Gradle/Kotlin plugin errors, iOS launch crashes or UIScene warnings. Holds per-release migration notes newer than most models know. Not for ordinary feature work in an up-to-date project.
---

# Flutter upgrade

Breaking changes are documented per release at
https://docs.flutter.dev/release/breaking-changes. This skill keeps the notes for the
**recent releases** (in `references/`), which are newer than most models' training data.

## Step 1 — Find the from- and to-versions

- **To:** the version the user names, else the SDK constraint in `pubspec.yaml`
  (`environment: flutter: ">=3.47.0"`), else latest stable.
- **From:** what the user says, else `.metadata` / an older constraint / `flutter --version`
  output they paste. If unknown, assume one stable release earlier than the target and say so.

## Step 2 — Read every release note in between

Read **each** `references/<version>.md` with `from < version <= to`, oldest first. Changes
stack: an app jumping 3.41 → 3.47 needs both 3.44 and 3.47.

| File | Release | Headline changes |
|---|---|---|
| `references/3.38.md` | Nov 2025 | UIScene lifecycle on iOS (required by Xcode 27) |
| `references/3.44.md` | May 2026 | AGP 9 + built-in Kotlin (temporary KGP support), `IconData` final, `onReorderItem`, `ScrollCacheExtent`, CupertinoPageTransitionsBuilder moved |
| `references/3.47.md` | Aug 2026 | standalone `material_ui` / `cupertino_ui`, `describeEnum` removed, built-in Kotlin can be enabled, iOS 15 / macOS 12 minimum, Wasm needs `package:web` |

Older releases: the model generally knows them; consult the official index if needed.

## Step 3 — Apply in this order

1. `flutter upgrade` (or pin with FVM) → `flutter pub upgrade --major-versions` for plugins.
2. `dart fix --apply` — handles many renames automatically. Several recent changes are
   **not** covered by `dart fix` (noted in the references); fix those by hand.
3. Platform projects: Android Gradle files, iOS `AppDelegate` / `Info.plist` (see references).
   `flutter run` / `flutter build` also run automatic migrators — they only handle
   *unmodified* template files.
4. `flutter analyze`, then build both platforms.

## Rules

- Migrate properly. Never silence errors with `// ignore`, casts, or by downgrading the SDK,
  AGP or Xcode, unless the user asks for a temporary stopgap — then label it as one.
- When a change alters semantics (e.g. `onReorderItem`'s `newIndex`), adjust the logic, not
  just the name.
- Opt-in migrations (e.g. `material_ui`) are not required by the upgrade itself. Mention them
  once; do them when asked or when the project already opted in.
- Show every changed file in full when the user asks for files.
- Say what you could not verify (no SDK or device available) and the command that checks it.

## Adding a new release

Create `references/<version>.md` from the official breaking-changes index: one section per
change with *what changed*, *symptom/error*, *before/after code*, and whether `dart fix` covers
it. Add a row to the table above.
