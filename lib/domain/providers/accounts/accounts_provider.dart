import 'package:aad/domain/models/account_details.dart';
import 'package:aad/domain/repository/account_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accounts_provider.g.dart';

@riverpod
Future<List<AccountDetails>> accounts(Ref ref) {
  return ref.watch(accountRepositoryProvider).listAccountsWithBalance();
}
