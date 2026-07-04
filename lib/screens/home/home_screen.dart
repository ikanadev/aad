import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aad/domain/providers/accounts/accounts_provider.dart';
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
            Text('Accounts', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            accountsValue.when(
              data: (accounts) {
                if (accounts.isEmpty) {
                  return Card(
                    child: InkWell(
                      onTap: () => context.push('/accounts'),
                      child: const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('No accounts yet.')),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    for (final account in accounts)
                      AccountItem(
                        account: account,
                        onTap: () => context.push('/accounts'),
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
}
