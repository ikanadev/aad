import 'package:aad/dev/dev_seeder.dart';
import 'package:aad/domain/models/category.dart';
import 'package:aad/utils/db_constants.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

import 'models/accounts.dart';
import 'models/categories.dart';
import 'models/transactions.dart';

part 'database.g.dart';

@DriftDatabase(tables: [DbAccounts, DbCategories, DbTransactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        const id = Uuid();
        const name = kAccountBalanceCategoryName;
        for (final category in [
          (type: CategoryType.income, color: 'emerald', iconName: 'positiveAdjustment'),
          (type: CategoryType.expense, color: 'rose', iconName: 'negativeAdjustment'),
        ]) {
          final existing =
              await (select(dbCategories)..where(
                    (c) =>
                        c.type.equals(category.type.dbValue) &
                        c.name.equals(name),
                  ))
                  .getSingleOrNull();
          if (existing != null) continue;
          await into(dbCategories).insert(
            DbCategory(
              id: id.v4(),
              name: name,
              iconName: category.iconName,
              type: category.type.dbValue,
              color: category.color,
              sortOrder: -1,
              isSystem: true,
              serverVersion: 0,
              isDirty: true,
              isDeleted: false,
            ),
          );
        }
        if (shouldSeedDevData) {
          await seedDevData(this);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'aad_database');
  }
}
