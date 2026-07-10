import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:aad/db/database.dart';
import 'package:aad/domain/models/account.dart';

class AccountRepository {
  AccountRepository(this._database);

  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Future<String> createAccount({
    required String name,
    required String currencyCode,
    required String color,
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
              color: Value(color),
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
    required String color,
    required bool isDefault,
  }) async {
    await _database.transaction(() async {
      if (isDefault) await _clearDefaultAccount();

      await (_database.update(
        _database.dbAccounts,
      )..where((account) => account.id.equals(id))).write(
        DbAccountsCompanion(
          name: Value(name.trim()),
          color: Value(color),
          isDefault: Value(isDefault),
          isDirty: const Value(true),
        ),
      );
    });
  }

  Future<void> deleteAccount({required String id}) async {
    await _database.transaction(() async {
      await (_database.update(
        _database.dbAccounts,
      )..where((account) => account.id.equals(id))).write(
        const DbAccountsCompanion(
          isDeleted: Value(true),
          isDefault: Value(false),
          isDirty: Value(true),
        ),
      );

      // Cascade: an account's transactions go with it, so lists, totals and
      // stats never show entries for an account that no longer exists.
      await (_database.update(
        _database.dbTransactions,
      )..where((t) => t.accountId.equals(id))).write(
        const DbTransactionsCompanion(
          isDeleted: Value(true),
          isDirty: Value(true),
        ),
      );
    });
  }

  Future<void> _clearDefaultAccount() async {
    await (_database.update(
      _database.dbAccounts,
    )..where((account) => account.isDefault.equals(true))).write(
      const DbAccountsCompanion(isDefault: Value(false), isDirty: Value(true)),
    );
  }
}
