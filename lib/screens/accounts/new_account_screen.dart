import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aad/domain/providers/accounts/account_actions_provider.dart';
import 'package:aad/screens/accounts/widgets/account_form.dart';

class NewAccountScreen extends ConsumerWidget {
  const NewAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add account')),
      body: AccountForm(
        submitLabel: 'Create account',
        onSubmit: (name, currencyCode, color, isDefault) =>
            _create(context, ref, name, currencyCode, color, isDefault),
      ),
    );
  }

  Future<void> _create(
    BuildContext context,
    WidgetRef ref,
    String name,
    String currencyCode,
    String color,
    bool isDefault,
  ) async {
    await ref
        .read(accountActionsProvider.notifier)
        .createAccount(
          name: name,
          currencyCode: currencyCode,
          color: color,
          isDefault: isDefault,
        );

    if (context.mounted) context.pop();
  }
}
