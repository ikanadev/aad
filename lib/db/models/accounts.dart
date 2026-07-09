import 'package:drift/drift.dart';

class DbAccounts extends Table {
  late final id = text()();

  late final name = text()();

  late final currencyCode = text()();

  late final isDefault = boolean().withDefault(const Constant(false))();

  late final serverVersion = real().withDefault(const Constant(0))();

  late final isDirty = boolean().withDefault(const Constant(false))();

  late final isDeleted = boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
