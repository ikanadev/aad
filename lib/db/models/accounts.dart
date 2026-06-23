import 'package:drift/drift.dart';

class DbAccounts extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get currencyCode => text()();

  RealColumn get serverVersion => real().withDefault(const Constant(0))();

  BoolColumn get isDirty => boolean().withDefault(const Constant(false))();

  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
