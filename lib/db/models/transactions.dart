import 'package:drift/drift.dart';

@TableIndex(
  name: 'idx_transactions_account_deleted_date',
  columns: {#accountId, #isDeleted, #date},
)
@TableIndex(
  name: 'idx_transactions_deleted_date',
  columns: {#isDeleted, #date},
)
@TableIndex(name: 'idx_transactions_category', columns: {#categoryId})
class DbTransactions extends Table {
  late final id = text()();

  late final accountId = text()();

  late final categoryId = text()();

  late final amount = integer()(); // stored in cents, always positive

  late final date = dateTime()();

  late final serverVersion = real().withDefault(const Constant(0))();

  late final isDirty = boolean().withDefault(const Constant(false))();

  late final isDeleted = boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
