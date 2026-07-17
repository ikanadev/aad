import 'package:flutter/material.dart';

import 'package:aad/domain/models/app_color.dart';
import 'package:aad/utils/app_theme.dart';
import 'package:aad/utils/currency_utils.dart';

class TotalBadge extends StatelessWidget {
  const TotalBadge({super.key, required this.currencyCode, required this.total});

  final String currencyCode;
  final int total;

  @override
  Widget build(BuildContext context) {
    final currency = currencyInfoByCode(currencyCode);
    final color = total < 0 ? expenseColor : incomeColor;
    final totalFormatted = (total / 100).toStringAsFixed(2);
    final sign = total > 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: 3),
      decoration: BoxDecoration(
        color: color.container,
        borderRadius: AppRadius.mdAll,
      ),
      child: Text(
        '$sign$totalFormatted ${currency.symbol} ${currency.code}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
