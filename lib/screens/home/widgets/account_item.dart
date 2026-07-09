import 'package:flutter/material.dart';

import 'package:aad/domain/models/account_details.dart';
import 'package:aad/screens/home/utils/currency_utils.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({super.key, required this.account, required this.onTap});

  final AccountDetails account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final currency = currencyInfoByCode(account.currencyCode);
    final balanceFormatted = (account.balance / 100).toStringAsFixed(2);

    return Card(
      child: ListTile(
        onTap: onTap,
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
        subtitle: Text('${currency.name} (${currency.code})'),
        trailing: Text(
          '$balanceFormatted ${currency.symbol} ${currency.code}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
