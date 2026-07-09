import 'package:aad/domain/models/account_details.dart';
import 'package:aad/domain/providers/accounts/accounts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'default_account_provider.g.dart';

@riverpod
Future<AccountDetails?> defaultAccount(Ref ref) async {
  final accounts = await ref.watch(accountsProvider.future);

  for (final account in accounts) {
    if (account.isDefault) return account;
  }
  return null;
}
