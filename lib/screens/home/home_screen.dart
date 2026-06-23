import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aad/domain/models/account.dart';
import 'package:aad/domain/providers/accounts/accounts_provider.dart';
import 'package:aad/screens/home/widgets/account_bottom_sheet.dart';
import 'package:aad/screens/home/widgets/account_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsValue = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(accountsProvider.future),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Accounts', style: Theme.of(context).textTheme.titleLarge),
                FilledButton.icon(
                  onPressed: () => _showCreateAccountSheet(context, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            accountsValue.when(
              data: (accounts) {
                if (accounts.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('No accounts yet.')),
                    ),
                  );
                }

                return Column(
                  children: [
                    for (final account in accounts)
                      AccountItem(
                        account: account,
                        onEdit: () =>
                            _showEditAccountSheet(context, ref, account),
                        onRemove: () =>
                            _confirmRemoveAccount(context, ref, account),
                      ),
                  ],
                );
              },
              error: (error, stackTrace) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Could not load accounts: $error'),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCreateAccountSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final result = await showModalBottomSheet<AccountBottomSheetResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AccountBottomSheet(),
    );

    if (result == null) return;

    await ref
        .read(accountsProvider.notifier)
        .createAccount(name: result.name, currencyCode: result.currencyCode);
  }

  Future<void> _showEditAccountSheet(
    BuildContext context,
    WidgetRef ref,
    Account account,
  ) async {
    final result = await showModalBottomSheet<AccountBottomSheetResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AccountBottomSheet(account: account),
    );

    if (result == null) return;

    await ref
        .read(accountsProvider.notifier)
        .editAccount(id: account.id, name: result.name);
  }

  Future<void> _confirmRemoveAccount(
    BuildContext context,
    WidgetRef ref,
    Account account,
  ) async {
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

    if (confirmed != true) return;

    await ref
        .read(accountsProvider.notifier)
        .deleteAccount(id: account.id);
  }
}
