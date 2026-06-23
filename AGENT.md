# Flutter application
### Purpose
An offline first expenses and incomes management app, the main purpose is to allow the user to have some "accounts" in the app and record all kind of expenses there so he can visuallize his expenses. The expenses are recorded using categories, for each expense there should exist a a category an account, and each account has its own currency.

### Tech stack
Flutter with the following libraries:

  riverpod: Main data consumption for widgets and screens, always use code generation.
  go_router: App screens
  shared_preferences: Persistent simple storage
  drift: Offline database

### Database and dataflow
The database models are in `db/models` create a file for each entity.
Table includes these columns (for sync) alongside business columns:
```
RealColumn get serverVersion => real()();         // Last known server version for this row
BoolColumn get isDirty => boolean().withDefault(const Constant(false))();  
BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
```

### Directory structure
In `domain/models/` we'll store all models used in the app, the app should only receive and use those models, they basically replicate the db models but only exposes needed data, also each model should have a `toDB` and `fromDB` utilities to parse.

In `domain/repository/` we'll have all the database repositories that interact with the database and return domain models, also for each repository we'll have a riverpod provider.

The `domain/providers/[feature]` will hold repositories per feature, they can or can't interact with the database via the repository providers. All the screens or widgets can interact only with these providers.

The ui lives in `screens/[screen_name]` where the file is names `[screen_name]_screen.dart` ex. `screens/home/home_screen.dart` . If we need to create helper component that are used only in the screen we store it in `screens/[screen_name]/widgets/` also we can have utils if needed.

The shared widgets should be in `widgets/` directory.
