import 'package:drift/drift.dart';

import 'package:aad/db/database.dart';
import 'package:aad/domain/models/app_color.dart';

class Account {
  final String id;
  final String name;
  final String currencyCode;
  final String color;
  final bool isDefault;

  const Account({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.color,
    required this.isDefault,
  });

  AppColor get appColor => AppColor.byName(color);

  factory Account.fromDB(DbAccount row) {
    return Account(
      id: row.id,
      name: row.name,
      currencyCode: row.currencyCode,
      color: row.color,
      isDefault: row.isDefault,
    );
  }

  DbAccountsCompanion toDB({bool isDirty = true}) {
    return DbAccountsCompanion(
      id: Value(id),
      name: Value(name),
      currencyCode: Value(currencyCode),
      color: Value(color),
      isDefault: Value(isDefault),
      isDirty: Value(isDirty),
    );
  }
}
