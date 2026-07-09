import 'package:aad/db/database.dart';
import 'package:aad/dev/dev_seeder.dart';
import 'package:aad/widgets/app_icon.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('seedDevData populates a fresh database', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await seedDevData(db);

    final accounts = await db.select(db.dbAccounts).get();
    final categories = await db.select(db.dbCategories).get();
    final transactions = await db.select(db.dbTransactions).get();

    expect(accounts, hasLength(3));
    expect(accounts.map((a) => a.currencyCode).toSet(), {'USD', 'BOB'});

    // 17 seeded + 2 system adjustment categories from onCreate.
    expect(categories, hasLength(19));
    expect(
      categories.every((c) => AppIcons.tryParse(c.iconName) != null),
      isTrue,
    );

    expect(transactions.length, greaterThan(300));
    expect(transactions.where((t) => t.isDeleted), hasLength(2));
    expect(transactions.every((t) => t.amount > 0), isTrue);

    final now = DateTime.now();
    final today = transactions.where(
      (t) =>
          !t.isDeleted &&
          t.date.year == now.year &&
          t.date.month == now.month &&
          t.date.day == now.day,
    );
    expect(today.length, greaterThanOrEqualTo(3));

    final synced = transactions.where((t) => !t.isDirty && t.serverVersion == 1);
    final dirty = transactions.where((t) => t.isDirty && t.serverVersion == 0);
    expect(synced, isNotEmpty);
    expect(dirty, isNotEmpty);
  });
}
