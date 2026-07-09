import 'package:flutter/material.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/models/transaction_details.dart';
import 'package:aad/screens/home/utils/currency_utils.dart';

class TodayTotalsBadges extends StatelessWidget {
  const TodayTotalsBadges({super.key, required this.transactions});

  final List<TransactionDetails> transactions;

  @override
  Widget build(BuildContext context) {
    final totalsByCurrency = <String, int>{};
    for (final transaction in transactions) {
      final signedAmount = transaction.category.type == CategoryType.income
          ? transaction.amount
          : -transaction.amount;
      totalsByCurrency.update(
        transaction.account.currencyCode,
        (total) => total + signedAmount,
        ifAbsent: () => signedAmount,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final entry in totalsByCurrency.entries)
          _TotalBadge(currencyCode: entry.key, total: entry.value),
      ],
    );
  }
}

class _TotalBadge extends StatelessWidget {
  const _TotalBadge({required this.currencyCode, required this.total});

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
