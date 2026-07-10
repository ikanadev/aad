import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/models/year_stats.dart';
import 'package:flutter_test/flutter_test.dart';

Category _category(String id) => Category(
  id: id,
  name: id,
  iconName: 'food',
  type: CategoryType.expense,
  color: 'red',
  sortOrder: 0,
  isSystem: false,
);

void main() {
  final stats = YearStats(
    year: 2026,
    categoriesById: {'food': _category('food'), 'taxi': _category('taxi')},
    rows: const [
      MonthCategoryStat(
        month: 1,
        categoryId: 'food',
        currencyCode: 'USD',
        total: 250000,
      ),
      MonthCategoryStat(
        month: 1,
        categoryId: 'taxi',
        currencyCode: 'BOB',
        total: 312550,
      ),
      MonthCategoryStat(
        month: 3,
        categoryId: 'food',
        currencyCode: 'USD',
        total: 100000,
      ),
    ],
  );

  test('monthTotals groups by month and currency', () {
    expect(stats.monthTotals, {
      1: {'USD': 250000, 'BOB': 312550},
      3: {'USD': 100000},
    });
  });

  test('axisMax rounds the biggest month up to the next 1000 units', () {
    // January: 2500.00 + 3125.50 = 5625.50 -> 6000 units = 600000 cents.
    expect(stats.axisMax, 600000);
  });

  test('axisMax keeps exact multiples and empty years sane', () {
    final exact = YearStats(
      year: 2026,
      categoriesById: const {},
      rows: const [
        MonthCategoryStat(
          month: 5,
          categoryId: 'food',
          currencyCode: 'USD',
          total: 300000,
        ),
      ],
    );
    expect(exact.axisMax, 300000);

    const empty = YearStats(year: 2026, categoriesById: {}, rows: []);
    expect(empty.axisMax, YearStats.centsPerAxisStep);
  });

  test('categoryTotals sorts by naive cross-currency total descending', () {
    final totals = stats.categoryTotals();
    expect(totals.map((s) => s.category.id), ['food', 'taxi']);
    expect(totals.first.totalsByCurrency, {'USD': 350000});
    expect(totals.first.naiveTotal, 350000);
  });

  test('categoryTotals filters by month', () {
    final march = stats.categoryTotals(month: 3);
    expect(march.map((s) => s.category.id), ['food']);
    expect(march.first.totalsByCurrency, {'USD': 100000});

    expect(stats.categoryTotals(month: 2), isEmpty);
  });

  test('currencies are stable and sorted', () {
    expect(stats.currencies, ['BOB', 'USD']);
  });
}
