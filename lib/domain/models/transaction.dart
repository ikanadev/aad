import 'package:drift/drift.dart';

import 'package:aad/db/database.dart';

class Transaction {
  final String id;
  final String accountId;
  final String categoryId;
  final int amount; // cents, always positive
  final DateTime date;

  const Transaction({
    required this.id,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.date,
  });

  factory Transaction.fromDB(DbTransaction row) {
    return Transaction(
      id: row.id,
      accountId: row.accountId,
      categoryId: row.categoryId,
      amount: row.amount,
      date: row.date,
    );
  }

  DbTransactionsCompanion toDB({bool isDirty = true}) {
    return DbTransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      categoryId: Value(categoryId),
      amount: Value(amount),
      date: Value(date),
      isDirty: Value(isDirty),
    );
  }
}
