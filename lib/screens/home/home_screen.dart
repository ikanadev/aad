import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aad/domain/providers/accounts/accounts_provider.dart';
import 'package:aad/domain/providers/transactions/today_transactions_provider.dart';
import 'package:aad/screens/home/widgets/account_item.dart';
import 'package:aad/screens/home/widgets/today_totals_badges.dart';
import 'package:aad/utils/app_theme.dart';
import 'package:aad/widgets/empty_section.dart';
import 'package:aad/widgets/error_section.dart';
import 'package:aad/widgets/transaction_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsValue = ref.watch(accountsProvider);
    final todayTransactionsValue = ref.watch(todayTransactionsProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          ref.refresh(accountsProvider.future),
          ref.refresh(todayTransactionsProvider.future),
        ]),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.s16),
          children: [
            Text('Accounts', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.s12),
            accountsValue.when(
              data: (accounts) {
                if (accounts.isEmpty) {
                  return Column(
                    children: [
                      const EmptySection(text: 'No accounts yet.'),
                      const SizedBox(height: AppSpacing.s8),
                      FilledButton(
                        onPressed: () => context.push('/home/accounts'),
                        child: const Text('Add account'),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    for (final account in accounts)
                      AccountItem(
                        account: account,
                        onTap: () => context.push('/home/accounts'),
                      ),
                  ],
                );
              },
              error: (error, stackTrace) =>
                  ErrorSection(text: 'Could not load accounts: $error'),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),

            const SizedBox(height: AppSpacing.s24),

            Text('Today', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.s12),
            todayTransactionsValue.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const EmptySection(text: 'No transactions today.');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TodayTotalsBadges(transactions: transactions),
                    const SizedBox(height: AppSpacing.s4),
                    for (final transaction in transactions)
                      TransactionItem(
                        transaction: transaction,
                        onTap: transaction.category.isSystem
                            ? null
                            : () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('TODO: edit transaction'),
                                ),
                              ),
                      ),
                  ],
                );
              },
              error: (error, stackTrace) =>
                  ErrorSection(text: 'Could not load transactions: $error'),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
