import 'package:flutter/material.dart';

import 'package:aad/domain/models/app_color.dart';
import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/models/transaction_details.dart';
import 'package:aad/utils/currency_utils.dart';
import 'package:aad/widgets/app_icon.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction, this.onTap});

  final TransactionDetails transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final category = transaction.category;
    final color = category.appColor;
    final icon = AppIcons.tryParse(category.iconName);
    final currency = currencyInfoByCode(transaction.account.currencyCode);
    final isIncome = category.type == CategoryType.income;
    final amountFormatted = (transaction.amount / 100).toStringAsFixed(2);
    final sign = isIncome ? '+' : '-';

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.container,
          child: icon == null
              ? Icon(Icons.category_outlined, color: color.fill)
              : AppIcon(icon: icon, size: 22),
        ),
        title: Text(category.name),
        subtitle: Text(
          transaction.comment?.isNotEmpty == true
              ? '${transaction.account.name} · ${transaction.comment}'
              : transaction.account.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          '$sign$amountFormatted ${currency.symbol}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isIncome ? incomeColor.text : null,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
