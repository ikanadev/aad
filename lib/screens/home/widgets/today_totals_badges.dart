import 'package:flutter/material.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/models/transaction_details.dart';
import 'package:aad/widgets/total_badge.dart';

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
          TotalBadge(currencyCode: entry.key, total: entry.value),
      ],
    );
  }
}
