import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aad/domain/providers/accounts/accounts_provider.dart';
import 'package:aad/screens/home/widgets/account_item.dart';
import 'package:aad/utils/app_theme.dart';
import 'package:aad/widgets/empty_section.dart';
import 'package:aad/widgets/error_section.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsValue = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/home/accounts/new'),
        child: const Icon(Icons.add),
      ),
      body: accountsValue.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return const Center(child: EmptySection(text: 'No accounts yet.'));
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s16,
              AppSpacing.s16,
              AppSpacing.s16,
              96, // extra bottom clearance for the FAB
            ),
            children: [
              for (final account in accounts)
                AccountItem(
                  account: account,
                  onTap: () => context.push('/home/accounts/${account.id}/edit'),
                ),
            ],
          );
        },
        error: (error, stackTrace) => Center(
          child: ErrorSection(text: 'Could not load accounts: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
