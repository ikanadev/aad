import 'package:aad/db/database.dart';
import 'package:aad/domain/models/stats_filters.dart';
import 'package:aad/domain/repository/transaction_repository.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late TransactionRepository repository;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repository = TransactionRepository(db);

    await db.batch((batch) {
      batch.insertAll(db.dbAccounts, [
        DbAccountsCompanion.insert(id: 'usd', name: 'Cash', currencyCode: 'USD'),
        DbAccountsCompanion.insert(id: 'bob', name: 'Bank', currencyCode: 'BOB'),
      ]);
      batch.insertAll(db.dbCategories, [
        DbCategoriesCompanion.insert(
          id: 'food',
          name: 'Food',
          iconName: 'food',
          type: 'expense',
          color: 'red',
        ),
        DbCategoriesCompanion.insert(
          id: 'taxi',
          name: 'Taxi',
          iconName: 'taxi',
          type: 'expense',
          color: 'blue',
        ),
        DbCategoriesCompanion.insert(
          id: 'job',
          name: 'Job',
          iconName: 'job',
          type: 'income',
          color: 'green',
        ),
        DbCategoriesCompanion.insert(
          id: 'adjustment',
          name: 'Account Balance',
          iconName: 'negativeAdjustment',
          type: 'expense',
          color: 'gray',
          isSystem: const Value(true),
        ),
      ]);
    });
  });

  tearDown(() => db.close());

  Future<void> insertTx(
    String id,
    String accountId,
    String categoryId,
    int amount,
    DateTime date, {
    bool isDeleted = false,
  }) {
    return db
        .into(db.dbTransactions)
        .insert(
          DbTransactionsCompanion.insert(
            id: id,
            accountId: accountId,
            categoryId: categoryId,
            amount: amount,
            date: date,
            isDeleted: Value(isDeleted),
          ),
        );
  }

  test('aggregates by month, category and currency; expenses only', () async {
    await insertTx('t1', 'usd', 'food', 1000, DateTime(2026, 1, 5));
    await insertTx('t2', 'usd', 'food', 500, DateTime(2026, 1, 20));
    await insertTx('t3', 'bob', 'food', 700, DateTime(2026, 1, 10));
    await insertTx('t4', 'usd', 'taxi', 300, DateTime(2026, 3, 2));
    // Excluded: income, deleted, other year, system balance adjustment.
    await insertTx('t5', 'usd', 'job', 9999, DateTime(2026, 1, 15));
    await insertTx('t6', 'usd', 'food', 400, DateTime(2026, 2, 1), isDeleted: true);
    await insertTx('t7', 'usd', 'food', 800, DateTime(2025, 12, 31));
    await insertTx('t8', 'usd', 'adjustment', 5000, DateTime(2026, 1, 8));

    final stats = await repository.getYearExpenseStats(
      const StatsFilters(year: 2026),
    );

    expect(stats.year, 2026);
    expect(stats.monthTotals, {
      1: {'USD': 1500, 'BOB': 700},
      3: {'USD': 300},
    });
    expect(stats.categoriesById.keys.toSet(), {'food', 'taxi'});
    expect(stats.categoryTotals().map((s) => s.category.id), ['food', 'taxi']);
  });

  test('applies account and category filters', () async {
    await insertTx('t1', 'usd', 'food', 1000, DateTime(2026, 1, 5));
    await insertTx('t2', 'bob', 'food', 700, DateTime(2026, 1, 10));
    await insertTx('t3', 'usd', 'taxi', 300, DateTime(2026, 1, 2));

    final byAccount = await repository.getYearExpenseStats(
      const StatsFilters(year: 2026, accountIds: ['bob']),
    );
    expect(byAccount.monthTotals, {
      1: {'BOB': 700},
    });

    final byCategory = await repository.getYearExpenseStats(
      const StatsFilters(year: 2026, categoryIds: ['taxi']),
    );
    expect(byCategory.monthTotals, {
      1: {'USD': 300},
    });
  });
}
