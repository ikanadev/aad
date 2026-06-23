import 'package:flutter/material.dart';

import 'package:aad/domain/models/account.dart';
import 'package:aad/screens/home/utils/currency_utils.dart';

class AccountItem extends StatelessWidget {
  const AccountItem({
    super.key,
    required this.account,
    required this.onEdit,
    required this.onRemove,
  });

  final Account account;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final currency = currencyInfoByCode(account.currencyCode);

    return Card(
      child: ListTile(
        title: Text(account.name),
        subtitle: Text('${currency.name} (${currency.code})'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '0.00 ${currency.symbol} ${currency.code}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            PopupMenuButton<_AccountAction>(
              onSelected: (action) {
                switch (action) {
                  case _AccountAction.edit:
                    onEdit();
                  case _AccountAction.remove:
                    onRemove();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _AccountAction.edit,
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text('Edit'),
                  ),
                ),
                PopupMenuItem(
                  value: _AccountAction.remove,
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('Remove'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _AccountAction { edit, remove }
