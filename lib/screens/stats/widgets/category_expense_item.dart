import 'package:flutter/material.dart';

import 'package:aad/domain/models/year_stats.dart';
import 'package:aad/utils/currency_colors.dart';
import 'package:aad/utils/currency_utils.dart';
import 'package:aad/widgets/app_icon.dart';

class CategoryExpenseItem extends StatelessWidget {
  const CategoryExpenseItem({
    super.key,
    required this.stat,
    required this.widthFactor,
    required this.currencyOrder,
  });

  final CategoryStat stat;

  /// This category's naive total relative to the largest category (0..1].
  final double widthFactor;
  final List<String> currencyOrder;

  @override
  Widget build(BuildContext context) {
    final category = stat.category;
    final color = category.flutterColor;
    final icon = AppIcons.tryParse(category.iconName);

    final visible = [
      for (final currency in currencyOrder)
        if ((stat.totalsByCurrency[currency] ?? 0) > 0) currency,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withValues(alpha: 0.14),
            child: icon == null
                ? Icon(Icons.category_outlined, color: color, size: 20)
                : AppIcon(icon: icon, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 3),
                FractionallySizedBox(
                  widthFactor: widthFactor.clamp(0.02, 1.0),
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      height: 12,
                      child: Row(
                        children: [
                          for (final currency in visible)
                            Flexible(
                              flex: stat.totalsByCurrency[currency]!,
                              child: Container(color: currencyColor(currency)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    for (final currency in visible)
                      _AmountBadge(
                        currencyCode: currency,
                        amount: stat.totalsByCurrency[currency]!,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountBadge extends StatelessWidget {
  const _AmountBadge({required this.currencyCode, required this.amount});

  final String currencyCode;
  final int amount;

  @override
  Widget build(BuildContext context) {
    final currency = currencyInfoByCode(currencyCode);
    final color = currencyColor(currencyCode);
    final amountFormatted = (amount / 100).toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$amountFormatted ${currency.symbol} ${currency.code}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
