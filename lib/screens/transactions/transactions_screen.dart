import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aad/domain/providers/transactions/currency_totals_provider.dart';
import 'package:aad/domain/providers/transactions/transaction_filters_provider.dart';
import 'package:aad/domain/providers/transactions/transactions_provider.dart';
import 'package:aad/screens/transactions/widgets/range_navigator.dart';
import 'package:aad/screens/transactions/widgets/range_type_selector.dart';
import 'package:aad/widgets/total_badge.dart';
import 'package:aad/widgets/transaction_item.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(transactionFiltersProvider);
    final filtersNotifier = ref.read(
      transactionFiltersProvider.notifier,
    );
    final totalsValue = ref.watch(currencyTotalsProvider(filters));
    final transactionsValue = ref.watch(transactionsListProvider(filters));

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RangeTypeSelector(
            selected: filters.rangeType,
            onSelected: filtersNotifier.setRangeType,
          ),
          const SizedBox(height: 12),
          RangeNavigator(
            filters: filters,
            onPrevious: filtersNotifier.previousRange,
            onNext: filtersNotifier.nextRange,
          ),
          const SizedBox(height: 12),
          totalsValue.when(
            data: (totals) => totals.isEmpty
                ? const SizedBox.shrink()
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final entry in totals.entries)
                        TotalBadge(currencyCode: entry.key, total: entry.value),
                    ],
                  ),
            error: (error, stackTrace) => Text('Could not load totals: $error'),
            loading: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: 12),
          transactionsValue.when(
            data: (transactionList) {
              if (transactionList.items.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('No transactions in this range.'),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  for (final transaction in transactionList.items)
                    TransactionItem(transaction: transaction),
                  if (transactionList.hasMore)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: OutlinedButton(
                        onPressed: () => ref
                            .read(transactionsListProvider(filters).notifier)
                            .loadMore(),
                        child: const Text('Load more'),
                      ),
                    ),
                ],
              );
            },
            error: (error, stackTrace) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Could not load transactions: $error'),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
