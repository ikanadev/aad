import 'package:aad/domain/providers/transactions/today_transactions_provider.dart';
import 'package:aad/domain/providers/transactions/transactions_provider.dart';
import 'package:aad/domain/repository/transaction_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_actions_provider.g.dart';

@riverpod
class TransactionActions extends _$TransactionActions {
  @override
  FutureOr<void> build() {}

  Future<void> createTransaction({
    required String accountId,
    required String categoryId,
    required int amount,
    required DateTime date,
  }) async {
    await ref.read(transactionRepositoryProvider).createTransaction(
      accountId: accountId,
      categoryId: categoryId,
      amount: amount,
      date: date,
    );
    _invalidate();
  }

  Future<void> editTransaction({
    required String id,
    required String categoryId,
    required int amount,
    required DateTime date,
  }) async {
    await ref.read(transactionRepositoryProvider).editTransaction(
      id: id,
      categoryId: categoryId,
      amount: amount,
      date: date,
    );
    _invalidate();
  }

  Future<void> deleteTransaction({required String id}) async {
    await ref.read(transactionRepositoryProvider).deleteTransaction(id: id);
    _invalidate();
  }

  void _invalidate() {
    ref.invalidate(transactionsListProvider);
    ref.invalidate(todayTransactionsProvider);
  }
}
