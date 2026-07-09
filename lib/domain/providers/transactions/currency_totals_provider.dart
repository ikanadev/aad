import 'package:aad/domain/models/transaction_filters.dart';
import 'package:aad/domain/repository/transaction_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currency_totals_provider.g.dart';

@riverpod
Future<Map<String, int>> currencyTotals(Ref ref, TransactionFilters filters) {
  return ref.watch(transactionRepositoryProvider).getTotalsByCurrency(filters);
}
