import 'package:drift/drift.dart';

import 'package:aad/db/database.dart';

class Account {
  final String id;
  final String name;
  final String currencyCode;
  final bool isDefault;

  const Account({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.isDefault,
  });

  factory Account.fromDB(DbAccount row) {
    return Account(
      id: row.id,
      name: row.name,
      currencyCode: row.currencyCode,
      isDefault: row.isDefault,
    );
  }

  DbAccountsCompanion toDB({bool isDirty = true}) {
    return DbAccountsCompanion(
      id: Value(id),
      name: Value(name),
      currencyCode: Value(currencyCode),
      isDefault: Value(isDefault),
      isDirty: Value(isDirty),
    );
  }
}
