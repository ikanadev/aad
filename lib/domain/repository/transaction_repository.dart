import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:aad/db/database.dart';
import 'package:aad/domain/models/transaction_details.dart';
import 'package:aad/domain/models/transaction_filters.dart';

class TransactionRepository {
  TransactionRepository(this._database);

  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Future<List<TransactionDetails>> listTodayTransactions() {
    final now = DateTime.now();
    return _queryTransactions(
      filters: TransactionFilters(
        from: DateTime(now.year, now.month, now.day),
        to: DateTime(now.year, now.month, now.day, 23, 59, 59, 999),
      ),
    );
  }

  Future<List<TransactionDetails>> listTransactions({
    TransactionFilters filters = const TransactionFilters(),
    int page = 0,
    int pageSize = 20,
  }) {
    return _queryTransactions(
      filters: filters,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<String> createTransaction({
    required String accountId,
    required String categoryId,
    required int amount,
    required DateTime date,
  }) async {
    final id = _uuid.v4();

    await _database
        .into(_database.dbTransactions)
        .insert(
          DbTransactionsCompanion.insert(
            id: id,
            accountId: accountId,
            categoryId: categoryId,
            amount: amount,
            date: date,
            serverVersion: const Value(0),
            isDirty: const Value(true),
            isDeleted: const Value(false),
          ),
        );

    return id;
  }

  Future<void> editTransaction({
    required String id,
    required String categoryId,
    required int amount,
    required DateTime date,
  }) async {
    await (_database.update(
      _database.dbTransactions,
    )..where((t) => t.id.equals(id))).write(
      DbTransactionsCompanion(
        categoryId: Value(categoryId),
        amount: Value(amount),
        date: Value(date),
        isDirty: const Value(true),
      ),
    );
  }

  Future<void> deleteTransaction({required String id}) async {
    await (_database.update(
      _database.dbTransactions,
    )..where((t) => t.id.equals(id))).write(
      const DbTransactionsCompanion(
        isDeleted: Value(true),
        isDirty: Value(true),
      ),
    );
  }

  Future<int> getAccountBalance(String accountId) async {
    final result = await _database.customSelect(
      '''
      SELECT COALESCE(SUM(
        CASE WHEN c.type = 'income' THEN t.amount ELSE -t.amount END
      ), 0) AS balance
      FROM db_transactions t
      INNER JOIN db_categories c ON c.id = t.category_id
      WHERE t.account_id = ? AND t.is_deleted = 0
      ''',
      variables: [Variable.withString(accountId)],
      readsFrom: {_database.dbTransactions, _database.dbCategories},
    ).getSingle();

    return result.read<int>('balance');
  }

  Future<List<TransactionDetails>> _queryTransactions({
    TransactionFilters filters = const TransactionFilters(),
    int? page,
    int pageSize = 20,
  }) async {
    final t = _database.dbTransactions;
    final a = _database.dbAccounts;
    final c = _database.dbCategories;

    final query = _database.select(t).join([
      innerJoin(a, a.id.equalsExp(t.accountId)),
      innerJoin(c, c.id.equalsExp(t.categoryId)),
    ]);

    query.where(t.isDeleted.equals(false));

    if (filters.accountIds?.isNotEmpty == true) {
      query.where(t.accountId.isIn(filters.accountIds!));
    }
    if (filters.categoryIds?.isNotEmpty == true) {
      query.where(t.categoryId.isIn(filters.categoryIds!));
    }
    if (filters.from != null) {
      query.where(t.date.isBiggerOrEqualValue(filters.from!));
    }
    if (filters.to != null) {
      query.where(t.date.isSmallerOrEqualValue(filters.to!));
    }

    final orderingMode = filters.direction == SortDirection.asc
        ? OrderingMode.asc
        : OrderingMode.desc;

    query.orderBy([
      if (filters.sortBy == TransactionSortField.date)
        OrderingTerm(expression: t.date, mode: orderingMode)
      else
        OrderingTerm(expression: t.amount, mode: orderingMode),
    ]);

    if (page != null) {
      query.limit(pageSize, offset: page * pageSize);
    }

    final rows = await query.get();
    return rows
        .map(
          (row) => TransactionDetails.fromDB(
            transaction: row.readTable(t),
            account: row.readTable(a),
            category: row.readTable(c),
          ),
        )
        .toList();
  }
}
