import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:aad/db/database.dart';
import 'package:aad/domain/models/account.dart';
import 'package:aad/domain/models/account_details.dart';

class AccountRepository {
  AccountRepository(this._database);

  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Future<String> createAccount({
    required String name,
    required String currencyCode,
    required bool isDefault,
  }) async {
    final id = _uuid.v4();

    await _database.transaction(() async {
      if (isDefault) await _clearDefaultAccount();

      await _database
          .into(_database.dbAccounts)
          .insert(
            DbAccountsCompanion.insert(
              id: id,
              name: name.trim(),
              currencyCode: currencyCode.trim().toUpperCase(),
              isDefault: Value(isDefault),
              serverVersion: const Value(0),
              isDirty: const Value(true),
              isDeleted: const Value(false),
            ),
          );
    });

    return id;
  }

  Future<List<Account>> listAccounts() async {
    final rows =
        await (_database.select(_database.dbAccounts)
              ..where((account) => account.isDeleted.equals(false))
              ..orderBy([(account) => OrderingTerm.asc(account.name)]))
            .get();

    return rows.map(Account.fromDB).toList();
  }

  Future<void> editAccount({
    required String id,
    required String name,
    required bool isDefault,
  }) async {
    await _database.transaction(() async {
      if (isDefault) await _clearDefaultAccount();

      await (_database.update(
        _database.dbAccounts,
      )..where((account) => account.id.equals(id))).write(
        DbAccountsCompanion(
          name: Value(name.trim()),
          isDefault: Value(isDefault),
          isDirty: const Value(true),
        ),
      );
    });
  }

  Future<void> deleteAccount({required String id}) async {
    await (_database.update(
      _database.dbAccounts,
    )..where((account) => account.id.equals(id))).write(
      const DbAccountsCompanion(
        isDeleted: Value(true),
        isDefault: Value(false),
        isDirty: Value(true),
      ),
    );
  }

  Future<void> _clearDefaultAccount() async {
    await (_database.update(
      _database.dbAccounts,
    )..where((account) => account.isDefault.equals(true))).write(
      const DbAccountsCompanion(isDefault: Value(false), isDirty: Value(true)),
    );
  }

  Future<List<AccountDetails>> listAccountsWithBalance() async {
    final accounts = await listAccounts();

    final rows = await _database.customSelect(
      'SELECT t.account_id, '
      'SUM(CASE WHEN c.type = \'income\' THEN t.amount ELSE 0 END) '
      '- SUM(CASE WHEN c.type = \'expense\' THEN t.amount ELSE 0 END) AS balance '
      'FROM db_transactions t '
      'JOIN db_categories c ON t.category_id = c.id '
      'WHERE t.is_deleted = 0 '
      'GROUP BY t.account_id',
      readsFrom: {_database.dbTransactions, _database.dbCategories},
    ).get();

    final balanceMap = {
      for (final row in rows)
        row.read<String>('account_id'): row.read<int>('balance'),
    };

    return accounts
        .map(
          (account) => AccountDetails.fromAccount(
            account,
            balance: balanceMap[account.id] ?? 0,
          ),
        )
        .toList();
  }
}
