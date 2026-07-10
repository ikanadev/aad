import 'package:aad/domain/models/account_details.dart';
import 'package:aad/domain/repository/account_repository_provider.dart';
import 'package:aad/domain/repository/transaction_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_provider.g.dart';

@riverpod
Future<List<AccountDetails>> accounts(Ref ref) async {
  final accounts = await ref.watch(accountRepositoryProvider).listAccounts();
  final balances = await ref
      .watch(transactionRepositoryProvider)
      .getBalancesByAccount();

  return [
    for (final account in accounts)
      AccountDetails.fromAccount(account, balance: balances[account.id] ?? 0),
  ];
}
