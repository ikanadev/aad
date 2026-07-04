import 'package:aad/domain/providers/accounts/accounts_provider.dart';
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
  }) async {
    await ref
        .read(accountRepositoryProvider)
        .createAccount(name: name, currencyCode: currencyCode);
    ref.invalidate(accountsProvider);
  }

  Future<void> editAccount({required String id, required String name}) async {
    await ref
        .read(accountRepositoryProvider)
        .editAccountName(id: id, name: name);
    ref.invalidate(accountsProvider);
  }

  Future<void> deleteAccount({required String id}) async {
    await ref.read(accountRepositoryProvider).deleteAccount(id: id);
    ref.invalidate(accountsProvider);
  }
}
