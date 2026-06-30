import 'package:aad/domain/models/account.dart';
import 'package:aad/domain/repository/account_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_provider.g.dart';

@riverpod
Future<List<Account>> accounts(Ref ref) {
  return ref.watch(accountRepositoryProvider).listAccounts();
}
