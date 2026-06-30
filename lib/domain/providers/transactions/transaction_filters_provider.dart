import 'package:aad/domain/models/transaction_filters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_filters_provider.g.dart';

@riverpod
class TransactionFiltersNotifier extends _$TransactionFiltersNotifier {
  @override
  TransactionFilters build() => const TransactionFilters();

  void update(TransactionFilters filters) => state = filters;

  void reset() => state = const TransactionFilters();
}
