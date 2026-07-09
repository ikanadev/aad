import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aad/domain/models/account_details.dart';
import 'package:aad/domain/providers/accounts/account_actions_provider.dart';
import 'package:aad/domain/providers/accounts/accounts_provider.dart';
import 'package:aad/screens/accounts/widgets/account_form.dart';
import 'package:aad/screens/accounts/widgets/adjust_balance_sheet.dart';

class EditAccountScreen extends ConsumerStatefulWidget {
  const EditAccountScreen({super.key, required this.accountId});

  final String accountId;

  @override
  ConsumerState<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends ConsumerState<EditAccountScreen> {
  bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    final accountsValue = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit account'),
        actions: [
          IconButton(
            tooltip: 'Remove account',
            onPressed: _deleting ? null : _confirmRemove,
            icon: _deleting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: accountsValue.when(
        data: (accounts) {
          final account = _findAccount(accounts);
          if (account == null) {
            return const Center(child: Text('Account not found.'));
          }

          return AccountForm(
            account: account,
            submitLabel: 'Save changes',
            onSubmit: (name, currencyCode, isDefault) =>
                _save(name, isDefault),
            onAdjustBalance: () =>
                showAdjustBalanceSheet(context, account: account),
          );
        },
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Could not load account: $error'),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  AccountDetails? _findAccount(List<AccountDetails> accounts) {
    for (final account in accounts) {
      if (account.id == widget.accountId) return account;
    }
    return null;
  }

  Future<void> _save(String name, bool isDefault) async {
    await ref
        .read(accountActionsProvider.notifier)
        .editAccount(id: widget.accountId, name: name, isDefault: isDefault);

    if (mounted) context.pop();
  }

  Future<void> _confirmRemove() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove account?'),
        content: const Text(
          'All the related transactions will be lost forever.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);

    try {
      await ref
          .read(accountActionsProvider.notifier)
          .deleteAccount(id: widget.accountId);

      if (mounted) context.pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not remove account: $error')),
        );
        setState(() => _deleting = false);
      }
    }
  }
}
