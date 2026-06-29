import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'models/accounts.dart';
import 'models/categories.dart';

part 'database.g.dart';

@DriftDatabase(tables: [DbAccounts, DbCategories])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'aad_database');
  }
}
