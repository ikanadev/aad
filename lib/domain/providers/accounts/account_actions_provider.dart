import 'package:aad/domain/providers/accounts/accounts_provider.dart';
import 'package:aad/domain/providers/stats/year_stats_provider.dart';
import 'package:aad/domain/providers/transactions/currency_totals_provider.dart';
import 'package:aad/domain/providers/transactions/today_transactions_provider.dart';
import 'package:aad/domain/providers/transactions/transactions_provider.dart';
import 'package:aad/domain/repository/account_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_actions_provider.g.dart';

@Riverpod(keepAlive: true)
class AccountActions extends _$AccountActions {
  @override
  FutureOr<void> build() {}

  Future<void> createAccount({
    required String name,
    required String currencyCode,
    required bool isDefault,
  }) async {
    await ref
        .read(accountRepositoryProvider)
        .createAccount(
          name: name,
          currencyCode: currencyCode,
          isDefault: isDefault,
        );
    ref.invalidate(accountsProvider);
  }

  Future<void> editAccount({
    required String id,
    required String name,
    required bool isDefault,
  }) async {
    await ref
        .read(accountRepositoryProvider)
        .editAccount(id: id, name: name, isDefault: isDefault);
    ref.invalidate(accountsProvider);
  }

  Future<void> deleteAccount({required String id}) async {
    await ref.read(accountRepositoryProvider).deleteAccount(id: id);
    ref.invalidate(accountsProvider);
    // Deleting an account cascades to its transactions.
    ref.invalidate(transactionsListProvider);
    ref.invalidate(todayTransactionsProvider);
    ref.invalidate(currencyTotalsProvider);
    ref.invalidate(yearStatsProvider);
  }
}
