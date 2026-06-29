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
  }) async {
    final id = _uuid.v4();

    await _database
        .into(_database.dbAccounts)
        .insert(
          DbAccountsCompanion.insert(
            id: id,
            name: name.trim(),
            currencyCode: currencyCode.trim().toUpperCase(),
            serverVersion: const Value(0),
            isDirty: const Value(true),
            isDeleted: const Value(false),
          ),
        );

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

  Future<void> editAccountName({
    required String id,
    required String name,
  }) async {
    await (_database.update(
      _database.dbAccounts,
    )..where((account) => account.id.equals(id))).write(
      DbAccountsCompanion(
        name: Value(name.trim()),
        isDirty: const Value(true),
      ),
    );
  }

  Future<void> deleteAccount({required String id}) async {
    await (_database.update(
      _database.dbAccounts,
    )..where((account) => account.id.equals(id))).write(
      const DbAccountsCompanion(isDeleted: Value(true), isDirty: Value(true)),
    );
  }
}
