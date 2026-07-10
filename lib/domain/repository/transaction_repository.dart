import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:aad/db/database.dart';
import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/models/stats_filters.dart';
import 'package:aad/domain/models/transaction_details.dart';
import 'package:aad/domain/models/transaction_filters.dart';
import 'package:aad/domain/models/year_stats.dart';

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
    String? comment,
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
            comment: Value(comment),
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
    String? comment,
  }) async {
    await (_database.update(
      _database.dbTransactions,
    )..where((t) => t.id.equals(id))).write(
      DbTransactionsCompanion(
        categoryId: Value(categoryId),
        amount: Value(amount),
        date: Value(date),
        comment: Value(comment),
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

  Future<Map<String, int>> getTotalsByCurrency(
    TransactionFilters filters,
  ) async {
    final txs = _database.dbTransactions;
    final accs = _database.dbAccounts;
    final cats = _database.dbCategories;

    final incomeFilter = cats.type.equals(CategoryType.income.dbValue);
    final incomeSum = txs.amount.sum(filter: incomeFilter);
    final expenseSum = txs.amount.sum(filter: incomeFilter.not());

    final query = _database.selectOnly(txs).join([
      innerJoin(accs, accs.id.equalsExp(txs.accountId)),
      innerJoin(cats, cats.id.equalsExp(txs.categoryId)),
    ]);
    query.addColumns([accs.currencyCode, incomeSum, expenseSum]);
    _applyFilters(query, filters);
    query.groupBy([accs.currencyCode]);

    final rows = await query.get();
    return {
      for (final row in rows)
        row.read(accs.currencyCode)!:
            (row.read(incomeSum) ?? 0) - (row.read(expenseSum) ?? 0),
    };
  }

  Future<YearStats> getYearExpenseStats(StatsFilters filters) async {
    final txs = _database.dbTransactions;
    final accs = _database.dbAccounts;
    final cats = _database.dbCategories;

    final monthExpr = txs.date.month;
    final totalSum = txs.amount.sum();

    final query = _database.selectOnly(txs).join([
      innerJoin(accs, accs.id.equalsExp(txs.accountId)),
      innerJoin(cats, cats.id.equalsExp(txs.categoryId)),
    ]);
    query.addColumns([monthExpr, txs.categoryId, accs.currencyCode, totalSum]);

    query.where(txs.isDeleted.equals(false));
    query.where(cats.type.equals(CategoryType.expense.dbValue));
    // Balance adjustments are bookkeeping, not human spending.
    query.where(cats.isSystem.equals(false));
    query.where(txs.date.isBiggerOrEqualValue(filters.from));
    query.where(txs.date.isSmallerOrEqualValue(filters.to));
    if (filters.accountIds?.isNotEmpty == true) {
      query.where(txs.accountId.isIn(filters.accountIds!));
    }
    if (filters.categoryIds?.isNotEmpty == true) {
      query.where(txs.categoryId.isIn(filters.categoryIds!));
    }

    query.groupBy([monthExpr, txs.categoryId, accs.currencyCode]);

    final rows = await query.get();
    final stats = [
      for (final row in rows)
        MonthCategoryStat(
          month: row.read(monthExpr)!,
          categoryId: row.read(txs.categoryId)!,
          currencyCode: row.read(accs.currencyCode)!,
          total: row.read(totalSum) ?? 0,
        ),
    ];

    final categoryIds = stats.map((stat) => stat.categoryId).toSet();
    final categoryRows = categoryIds.isEmpty
        ? <DbCategory>[]
        : await (_database.select(
            cats,
          )..where((c) => c.id.isIn(categoryIds))).get();

    return YearStats(
      year: filters.year,
      rows: stats,
      categoriesById: {
        for (final row in categoryRows) row.id: Category.fromDB(row),
      },
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
    final txs = _database.dbTransactions;
    final accs = _database.dbAccounts;
    final cats = _database.dbCategories;

    final query = _database.select(txs).join([
      innerJoin(accs, accs.id.equalsExp(txs.accountId)),
      innerJoin(cats, cats.id.equalsExp(txs.categoryId)),
    ]);

    _applyFilters(query, filters);

    final orderingMode = filters.direction == SortDirection.asc
        ? OrderingMode.asc
        : OrderingMode.desc;

    query.orderBy([
      if (filters.sortBy == TransactionSortField.date)
        OrderingTerm(expression: txs.date, mode: orderingMode)
      else
        OrderingTerm(expression: txs.amount, mode: orderingMode),
    ]);

    if (page != null) {
      query.limit(pageSize, offset: page * pageSize);
    }

    final rows = await query.get();
    return rows
        .map(
          (row) => TransactionDetails.fromDB(
            transaction: row.readTable(txs),
            account: row.readTable(accs),
            category: row.readTable(cats),
          ),
        )
        .toList();
  }

  void _applyFilters(
    JoinedSelectStatement<HasResultSet, dynamic> query,
    TransactionFilters filters,
  ) {
    final txs = _database.dbTransactions;

    query.where(txs.isDeleted.equals(false));

    if (filters.accountIds?.isNotEmpty == true) {
      query.where(txs.accountId.isIn(filters.accountIds!));
    }
    if (filters.categoryIds?.isNotEmpty == true) {
      query.where(txs.categoryId.isIn(filters.categoryIds!));
    }
    if (filters.from != null) {
      query.where(txs.date.isBiggerOrEqualValue(filters.from!));
    }
    if (filters.to != null) {
      query.where(txs.date.isSmallerOrEqualValue(filters.to!));
    }
  }
}
