import 'package:aad/domain/models/category.dart';

/// One aggregated expense bucket: a (month, category, currency) sum.
class MonthCategoryStat {
  final int month; // 1-12
  final String categoryId;
  final String currencyCode;
  final int total; // cents

  const MonthCategoryStat({
    required this.month,
    required this.categoryId,
    required this.currencyCode,
    required this.total,
  });
}

class CategoryStat {
  final Category category;
  final Map<String, int> totalsByCurrency;

  const CategoryStat({required this.category, required this.totalsByCurrency});

  /// Cross-currency sum without conversion; only meaningful for sorting and
  /// relative bar widths, never shown to the user as a number.
  int get naiveTotal =>
      totalsByCurrency.values.fold(0, (sum, value) => sum + value);
}

class YearStats {
  static const centsPerAxisStep = 100000; // one grid line per 1000 units

  final int year;
  final List<MonthCategoryStat> rows;
  final Map<String, Category> categoriesById;

  const YearStats({
    required this.year,
    required this.rows,
    required this.categoriesById,
  });

  /// Currencies present in the year's data, in stable (alphabetical) order so
  /// stacked segments and legends always match.
  List<String> get currencies =>
      rows.map((row) => row.currencyCode).toSet().toList()..sort();

  /// month (1-12) -> currency -> total. Months without expenses are absent.
  Map<int, Map<String, int>> get monthTotals {
    final result = <int, Map<String, int>>{};
    for (final row in rows) {
      final byCurrency = result.putIfAbsent(row.month, () => {});
      byCurrency[row.currencyCode] =
          (byCurrency[row.currencyCode] ?? 0) + row.total;
    }
    return result;
  }

  /// Y-axis top in cents: the largest month's naive total rounded up to the
  /// next 1000 units. At least one step so an empty chart still has a scale.
  int get axisMax {
    var max = 0;
    for (final totals in monthTotals.values) {
      final sum = totals.values.fold(0, (a, b) => a + b);
      if (sum > max) max = sum;
    }
    final steps = (max + centsPerAxisStep - 1) ~/ centsPerAxisStep;
    return (steps == 0 ? 1 : steps) * centsPerAxisStep;
  }

  /// Per-category totals for the whole year, or a single month when given,
  /// sorted by naive cross-currency total descending.
  List<CategoryStat> categoryTotals({int? month}) {
    final byCategory = <String, Map<String, int>>{};
    for (final row in rows) {
      if (month != null && row.month != month) continue;
      final byCurrency = byCategory.putIfAbsent(row.categoryId, () => {});
      byCurrency[row.currencyCode] =
          (byCurrency[row.currencyCode] ?? 0) + row.total;
    }

    final stats = [
      for (final entry in byCategory.entries)
        if (categoriesById[entry.key] != null)
          CategoryStat(
            category: categoriesById[entry.key]!,
            totalsByCurrency: entry.value,
          ),
    ];
    stats.sort((a, b) => b.naiveTotal.compareTo(a.naiveTotal));
    return stats;
  }
}
