import 'package:flutter/material.dart';

import 'package:aad/domain/models/account_details.dart';
import 'package:aad/utils/currency_utils.dart';
import 'package:aad/utils/money_text_style.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({super.key, required this.account, required this.onTap});

  final AccountDetails account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final currency = currencyInfoByCode(account.currencyCode);
    final balanceFormatted = (account.balance / 100).toStringAsFixed(2);

    final color = account.appColor;

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.container,
          child: Icon(Icons.account_balance_wallet_outlined, color: color.fill),
        ),
        title: Row(
          children: [
            Flexible(child: Text(account.name)),
            if (account.isDefault) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.star,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ],
        ),
        subtitle: Text(currency.name),
        trailing: Text(
          '$balanceFormatted ${currency.symbol}',
          style: Theme.of(context).textTheme.titleMedium?.income,
        ),
      ),
    );
  }
}
