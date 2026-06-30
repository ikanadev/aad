import 'package:aad/domain/models/transaction_details.dart';
import 'package:aad/domain/repository/transaction_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'today_transactions_provider.g.dart';

@riverpod
Future<List<TransactionDetails>> todayTransactions(Ref ref) {
  return ref.watch(transactionRepositoryProvider).listTodayTransactions();
}
