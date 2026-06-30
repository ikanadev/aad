import 'package:aad/db/db_provider.dart';
import 'package:aad/domain/repository/transaction_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_repository_provider.g.dart';

@riverpod
TransactionRepository transactionRepository(Ref ref) {
  return TransactionRepository(ref.watch(dbProvider));
}
