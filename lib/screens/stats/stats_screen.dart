import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aad/domain/providers/stats/selected_stats_month_provider.dart';
import 'package:aad/domain/providers/stats/stats_filters_provider.dart';
import 'package:aad/domain/providers/stats/year_stats_provider.dart';
import 'package:aad/screens/stats/widgets/category_expense_item.dart';
import 'package:aad/screens/stats/widgets/monthly_bar_chart.dart';
import 'package:aad/screens/stats/widgets/stats_filter_bar.dart';
import 'package:aad/screens/stats/widgets/year_navigator.dart';
import 'package:aad/utils/currency_colors.dart';

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(statsFiltersProvider);
    final filtersNotifier = ref.read(statsFiltersProvider.notifier);
    final selectedMonth = ref.watch(selectedStatsMonthProvider);
    final statsValue = ref.watch(yearStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Stats')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const StatsFilterBar(),
          const SizedBox(height: 8),
          YearNavigator(
            year: filters.year,
            onPrevious: filtersNotifier.previousYear,
            onNext: filters.year < DateTime.now().year
                ? filtersNotifier.nextYear
                : null,
          ),
          const SizedBox(height: 8),
          statsValue.when(
            data: (stats) {
              final categoryStats = stats.categoryTotals(month: selectedMonth);
              final maxTotal = categoryStats.isEmpty
                  ? 0
                  : categoryStats.first.naiveTotal;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (stats.currencies.isNotEmpty)
                    _CurrencyLegend(currencies: stats.currencies),
                  const SizedBox(height: 8),
                  MonthlyBarChart(
                    stats: stats,
                    selectedMonth: selectedMonth,
                    onMonthTap: ref
                        .read(selectedStatsMonthProvider.notifier)
                        .toggle,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    selectedMonth == null
                        ? 'All ${stats.year}'
                        : '${_monthNames[selectedMonth - 1]} ${stats.year}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (categoryStats.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text('No expenses in this period.'),
                        ),
                      ),
                    )
                  else
                    for (final stat in categoryStats)
                      CategoryExpenseItem(
                        stat: stat,
                        widthFactor: stat.naiveTotal / maxTotal,
                        currencyOrder: stats.currencies,
                      ),
                ],
              );
            },
            error: (error, stackTrace) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Could not load stats: $error'),
              ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyLegend extends StatelessWidget {
  const _CurrencyLegend({required this.currencies});

  final List<String> currencies;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: [
        for (final currency in currencies)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: currencyColor(currency),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(currency, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
      ],
    );
  }
}
