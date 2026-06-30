# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this app is

Offline-first expenses and incomes management app. Users create accounts (each with a currency), record transactions against categories, and view stats. All data lives locally in a Drift (SQLite) database with sync-ready columns on every table.

## Commands

```bash
# Run the app
flutter run

# Code generation (Drift + Riverpod) — must re-run after changing DB tables, providers, or annotations
dart run build_runner build --delete-conflicting-outputs

# Watch mode during development
dart run build_runner watch --delete-conflicting-outputs

# Lint
flutter analyze

# Tests
flutter test

# Compile SVG icons to .vec assets (run after adding/changing icons in design/icons/)
bash tool/build_icons.sh
```

## Architecture

Data flows strictly through layers — screens never touch the database directly.

```
db/models/          Drift table definitions (DbAccounts, DbCategories, …)
db/database.dart    AppDatabase — registers all tables, migration strategy

domain/models/      Plain Dart classes (Account, Category, …) with fromDB() and toDB()
domain/repository/  One repository class per entity; queries Drift, returns domain models
                    Each has a matching *_provider.dart (Riverpod @riverpod annotation)

domain/providers/[feature]/
                    Feature-level providers consumed by UI. They call repository providers
                    and hold mutations (create/edit/delete). Screens only interact here.

screens/[name]/     [name]_screen.dart + widgets/ subfolder for screen-local components
widgets/            Shared widgets used across screens
router.dart         All go_router routes in one place (StatefulShellRoute with 4 branches)
```

### Sync columns

Every syncable Drift table carries these three columns alongside business columns:

```dart
RealColumn get serverVersion => real().withDefault(const Constant(0))();
BoolColumn get isDirty => boolean().withDefault(const Constant(false))();
BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
```

Soft-delete via `isDeleted = true`; always filter `isDeleted.equals(false)` in list queries. The sync watermark (`lastSyncedVersion`, `needsBootstrap`) lives in SharedPreferences, not in the DB.

### Code generation

Drift and Riverpod both rely on `build_runner`. Generated files (`*.g.dart`) are committed. After changing a `@DriftDatabase`, table class, or `@riverpod` provider, regenerate before running.

### Icons

SVGs live in `design/icons/`. The `tool/build_icons.sh` script compiles them to `.vec` files in `assets/icons/vec/` using `vector_graphics_compiler`. Use `AppIcon` widget to render them.
