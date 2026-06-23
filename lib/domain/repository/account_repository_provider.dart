import 'package:aad/db/db_provider.dart';
import 'package:aad/domain/repository/account_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_repository_provider.g.dart';

@riverpod
AccountRepository accountRepository(Ref ref) {
  final db = ref.watch(dbProvider);
  return AccountRepository(db);
}
