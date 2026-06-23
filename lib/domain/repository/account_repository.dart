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
    final normalizedName = _normalizeName(name);
    final normalizedCurrencyCode = _normalizeCurrencyCode(currencyCode);
    final id = _uuid.v4();

    await _database.into(_database.dbAccounts).insert(
          DbAccountsCompanion.insert(
            id: id,
            name: normalizedName,
            currencyCode: normalizedCurrencyCode,
            serverVersion: const Value(0),
            isDirty: const Value(true),
            isDeleted: const Value(false),
          ),
        );

    return id;
  }

  Future<List<Account>> listAccounts() async {
    final rows = await (_database.select(_database.dbAccounts)
          ..where((account) => account.isDeleted.equals(false))
          ..orderBy([
            (account) => OrderingTerm.asc(account.name),
          ]))
        .get();

    return rows.map(Account.fromDB).toList();
  }

  Future<void> editAccountName({
    required String id,
    required String name,
  }) async {
    final normalizedName = _normalizeName(name);

    await (_database.update(_database.dbAccounts)
          ..where((account) => account.id.equals(id)))
        .write(
      DbAccountsCompanion(
        name: Value(normalizedName),
        isDirty: const Value(true),
      ),
    );
  }

  Future<void> deleteAccount({required String id}) async {
    await (_database.update(_database.dbAccounts)
          ..where((account) => account.id.equals(id)))
        .write(
      const DbAccountsCompanion(
        isDeleted: Value(true),
        isDirty: Value(true),
      ),
    );
  }

  String _normalizeName(String name) {
    final normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError('Account name cannot be empty');
    }
    return normalizedName;
  }

  String _normalizeCurrencyCode(String currencyCode) {
    final normalizedCurrencyCode = currencyCode.trim().toUpperCase();
    if (normalizedCurrencyCode.isEmpty) {
      throw ArgumentError('Currency code cannot be empty');
    }
    return normalizedCurrencyCode;
  }
}
