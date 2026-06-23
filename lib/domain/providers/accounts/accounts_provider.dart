import 'package:aad/domain/models/account.dart';
import 'package:aad/domain/repository/account_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_provider.g.dart';

@riverpod
class Accounts extends _$Accounts {
  @override
  Future<List<Account>> build() async {
    final accountRepository = ref.watch(accountRepositoryProvider);
    return await accountRepository.listAccounts();
  }

  Future<void> createAccount({
    required String name,
    required String currencyCode,
  }) async {
    final accountRepository = ref.read(accountRepositoryProvider);
    await accountRepository.createAccount(
      name: name,
      currencyCode: currencyCode,
    );
    ref.invalidateSelf();
  }

  Future<void> editAccount({required String id, required String name}) async {
    final accountRepository = ref.read(accountRepositoryProvider);
    await accountRepository.editAccountName(id: id, name: name);
    ref.invalidateSelf();
  }

  // TODO: remove associated stuff later
  Future<void> deleteAccount({required String id}) async {
    final accountRepository = ref.read(accountRepositoryProvider);
    await accountRepository.deleteAccount(id: id);
    ref.invalidateSelf();
  }
}
