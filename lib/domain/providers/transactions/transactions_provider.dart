import 'package:aad/domain/models/transaction_details.dart';
import 'package:aad/domain/models/transaction_filters.dart';
import 'package:aad/domain/repository/transaction_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_provider.g.dart';

class TransactionListState {
  final List<TransactionDetails> items;
  final bool hasMore;
  final TransactionFilters filters;

  const TransactionListState({
    required this.items,
    required this.hasMore,
    required this.filters,
  });

  TransactionListState copyWith({
    List<TransactionDetails>? items,
    bool? hasMore,
    TransactionFilters? filters,
  }) {
    return TransactionListState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      filters: filters ?? this.filters,
    );
  }
}

@riverpod
class TransactionsList extends _$TransactionsList {
  static const _pageSize = 20;

  @override
  Future<TransactionListState> build() async {
    const filters = TransactionFilters();
    final items = await ref
        .read(transactionRepositoryProvider)
        .listTransactions(filters: filters, page: 0, pageSize: _pageSize);
    return TransactionListState(
      items: items,
      hasMore: items.length == _pageSize,
      filters: filters,
    );
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || !current.hasMore) return;

    final nextPage = current.items.length ~/ _pageSize;
    final newItems = await ref
        .read(transactionRepositoryProvider)
        .listTransactions(
          filters: current.filters,
          page: nextPage,
          pageSize: _pageSize,
        );

    state = AsyncData(
      current.copyWith(
        items: [...current.items, ...newItems],
        hasMore: newItems.length == _pageSize,
      ),
    );
  }

  Future<void> applyFilters(TransactionFilters filters) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref
          .read(transactionRepositoryProvider)
          .listTransactions(filters: filters, page: 0, pageSize: _pageSize),
    );
    state = result.whenData(
      (items) => TransactionListState(
        items: items,
        hasMore: items.length == _pageSize,
        filters: filters,
      ),
    );
  }
}
