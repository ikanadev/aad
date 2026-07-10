import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:uuid/uuid.dart';

import 'package:aad/db/database.dart';
import 'package:aad/domain/models/account.dart';
import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/models/transaction.dart';

/// On by default in debug builds; disable with
/// `flutter run --dart-define=SEED_DATA=false`. Never runs in release builds
/// or under `flutter test`.
bool get shouldSeedDevData =>
    kDebugMode &&
    const bool.fromEnvironment('SEED_DATA', defaultValue: true) &&
    !Platform.environment.containsKey('FLUTTER_TEST');

const _uuid = Uuid();

/// Populates a freshly created database with deterministic dummy data:
/// accounts in two currencies, categories of both types, and ~6 months of
/// patterned transactions ending today. Amounts vary but the pattern is
/// reproducible (fixed Random seed); dates are relative to today so every
/// screen has current data.
Future<void> seedDevData(AppDatabase db) async {
  final random = Random(42);
  final now = DateTime.now();

  final cash = Account(
    id: _uuid.v4(),
    name: 'Cash',
    currencyCode: 'BOB',
    color: 'emerald',
    isDefault: true,
  );
  final bank = Account(
    id: _uuid.v4(),
    name: 'Bank',
    currencyCode: 'BOB',
    color: 'blue',
    isDefault: false,
  );
  final savings = Account(
    id: _uuid.v4(),
    name: 'Savings',
    currencyCode: 'USD',
    color: 'violet',
    isDefault: false,
  );
  final accounts = [cash, bank, savings];

  var expenseOrder = 0;
  var incomeOrder = 0;
  Category expenseCat(String name, String iconName, String color) => Category(
    id: _uuid.v4(),
    name: name,
    iconName: iconName,
    type: CategoryType.expense,
    color: color,
    sortOrder: expenseOrder++,
    isSystem: false,
  );
  Category incomeCat(String name, String iconName, String color) => Category(
    id: _uuid.v4(),
    name: name,
    iconName: iconName,
    type: CategoryType.income,
    color: color,
    sortOrder: incomeOrder++,
    isSystem: false,
  );

  final groceries = expenseCat('Groceries', 'groceries', 'lime');
  final rent = expenseCat('Rent', 'rent', 'indigo');
  final bills = expenseCat('Bills', 'bills', 'amber');
  final internet = expenseCat('Internet', 'internet', 'cyan');
  final taxi = expenseCat('Taxi', 'taxi', 'orange');
  final dinner = expenseCat('Dinner', 'dinner', 'pink');
  final drinks = expenseCat('Drinks', 'drinks', 'violet');
  final junkFood = expenseCat('Junk food', 'junkFood', 'rose');
  final medical = expenseCat('Medical', 'medical', 'teal');
  final clothes = expenseCat('Clothes', 'clothes', 'fuchsia');
  final travel = expenseCat('Travel', 'travel', 'blue');
  final entertainment = expenseCat('Entertainment', 'entretainment', 'emerald');
  final selfCare = expenseCat('Self care', 'selfCare', 'orange');
  final gifts = expenseCat('Gifts', 'gifts', 'violet');

  final job = incomeCat('Job', 'job', 'emerald');
  final crypto = incomeCat('Crypto', 'crypto', 'teal');
  final investments = incomeCat('Investments', 'grow', 'blue');

  final categories = [
    groceries, rent, bills, internet, taxi, dinner, drinks, junkFood,
    medical, clothes, travel, entertainment, selfCare, gifts,
    job, crypto, investments,
  ];

  final balanceIncome = Category.fromDB(
    await (db.select(db.dbCategories)..where(
          (c) =>
              c.isSystem.equals(true) &
              c.type.equals(CategoryType.income.dbValue),
        ))
        .getSingle(),
  );

  final transactions = <Transaction>[];
  void add(
    Account account,
    Category category,
    double amount,
    DateTime date, {
    String? comment,
  }) {
    transactions.add(
      Transaction(
        id: _uuid.v4(),
        accountId: account.id,
        categoryId: category.id,
        amount: (amount * 100).round(),
        date: date,
        comment: comment,
      ),
    );
  }

  double between(double min, double max) =>
      min + random.nextDouble() * (max - min);
  DateTime at(DateTime day) => DateTime(
    day.year,
    day.month,
    day.day,
    8 + random.nextInt(13),
    random.nextInt(60),
  );

  final start = DateTime(now.year, now.month - 5, 1);

  add(cash, balanceIncome, 5000, at(start), comment: 'Initial balance');
  add(bank, balanceIncome, 12000, at(start), comment: 'Initial balance');
  add(savings, balanceIncome, 2000, at(start), comment: 'Initial balance');

  for (var i = 5; i >= 0; i--) {
    void monthly(int day, void Function(DateTime date) create) {
      final date = DateTime(now.year, now.month - i, day);
      if (!date.isAfter(now)) create(at(date));
    }

    monthly(1, (d) => add(bank, job, between(6800, 7400), d, comment: 'Salary'));
    monthly(3, (d) => add(bank, rent, 2800, d));
    monthly(5, (d) => add(bank, internet, between(230, 280), d));
    monthly(8, (d) => add(bank, bills, between(150, 400), d));
    monthly(10, (d) => add(cash, balanceIncome, 1500, d, comment: 'ATM withdrawal'));
    monthly(15, (d) => add(savings, investments, between(150, 300), d));
  }

  for (
    var day = start;
    !day.isAfter(now);
    day = DateTime(day.year, day.month, day.day + 1)
  ) {
    final weekend = day.weekday >= DateTime.friday;
    // Everyday spending alternates between cash and the bank card.
    Account wallet() => random.nextDouble() < 0.4 ? cash : bank;

    if (random.nextDouble() < 0.45) {
      add(wallet(), groceries, between(40, 250), at(day));
    }
    if (random.nextDouble() < 0.35) add(cash, taxi, between(8, 35), at(day));
    if (random.nextDouble() < 0.30) {
      add(cash, junkFood, between(10, 45), at(day));
    }
    if (random.nextDouble() < (weekend ? 0.35 : 0.10)) {
      add(wallet(), dinner, between(60, 220), at(day));
    }
    if (weekend && random.nextDouble() < 0.30) {
      add(wallet(), drinks, between(50, 180), at(day));
    }
    if (random.nextDouble() < 0.08) {
      add(wallet(), entertainment, between(30, 150), at(day));
    }
    if (random.nextDouble() < 0.05) {
      add(wallet(), selfCare, between(50, 200), at(day));
    }
    if (random.nextDouble() < 0.04) {
      add(bank, clothes, between(120, 800), at(day));
    }
    if (random.nextDouble() < 0.03) {
      add(bank, medical, between(80, 600), at(day));
    }
    if (random.nextDouble() < 0.03) add(cash, gifts, between(30, 200), at(day));
    if (random.nextDouble() < 0.05) {
      add(savings, crypto, between(20, 120), at(day));
    }
  }

  add(
    bank,
    travel,
    1850,
    at(DateTime(now.year, now.month - 3, 12)),
    comment: 'Flights',
  );
  add(
    savings,
    travel,
    320,
    at(DateTime(now.year, now.month - 3, 14)),
    comment: 'Hotel',
  );

  // Guaranteed activity today so the home screen is never empty.
  add(cash, groceries, 132.50, DateTime(now.year, now.month, now.day, 9, 15));
  add(cash, taxi, 15, DateTime(now.year, now.month, now.day, 10, 40));
  add(cash, junkFood, 24, DateTime(now.year, now.month, now.day, 13, 5));

  // Rows older than two days pose as already synced; recent ones as pending,
  // so sync work later has both states to chew on from day one.
  final dirtyCutoff = DateTime(now.year, now.month, now.day - 2);
  final transactionRows = [
    for (final tx in transactions)
      if (tx.date.isBefore(dirtyCutoff))
        tx.toDB(isDirty: false).copyWith(serverVersion: const Value(1))
      else
        tx.toDB(),
  ];

  // Soft-deleted rows: visible anywhere in the UI means a missing
  // isDeleted filter.
  for (final (category, offsetDays) in [(groceries, 4), (dinner, 10)]) {
    final deleted = Transaction(
      id: _uuid.v4(),
      accountId: cash.id,
      categoryId: category.id,
      amount: 99900,
      date: at(DateTime(now.year, now.month, now.day - offsetDays)),
      comment: 'Soft-deleted seed row — must never appear',
    );
    transactionRows.add(
      deleted.toDB().copyWith(isDeleted: const Value(true)),
    );
  }

  await db.batch((batch) {
    batch.insertAll(
      db.dbAccounts,
      accounts.map(
        (a) => a.toDB(isDirty: false).copyWith(serverVersion: const Value(1)),
      ),
    );
    batch.insertAll(
      db.dbCategories,
      categories.map(
        (c) => c.toDB(isDirty: false).copyWith(serverVersion: const Value(1)),
      ),
    );
    batch.insertAll(db.dbTransactions, transactionRows);
  });
}
