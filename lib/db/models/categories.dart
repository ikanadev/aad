import 'package:drift/drift.dart';

class DbCategories extends Table {
  late final id = text()();

  late final name = text()();

  late final iconName = text()();

  late final type = text()();

  late final color = text()();

  late final sortOrder = integer().withDefault(const Constant(0))();

  late final isSystem = boolean().withDefault(const Constant(false))();

  late final serverVersion = real().withDefault(const Constant(0))();

  late final isDirty = boolean().withDefault(const Constant(false))();

  late final isDeleted = boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
