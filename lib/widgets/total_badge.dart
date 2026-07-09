import 'package:flutter/material.dart';

import 'package:aad/utils/currency_utils.dart';

class TotalBadge extends StatelessWidget {
  const TotalBadge({super.key, required this.currencyCode, required this.total});

  final String currencyCode;
  final int total;

  @override
  Widget build(BuildContext context) {
    final currency = currencyInfoByCode(currencyCode);
    final color = total < 0 ? Colors.red.shade600 : Colors.green.shade600;
    final totalFormatted = (total / 100).toStringAsFixed(2);
    final sign = total > 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$sign$totalFormatted ${currency.symbol} ${currency.code}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
