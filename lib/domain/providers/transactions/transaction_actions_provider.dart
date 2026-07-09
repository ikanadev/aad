import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/providers/accounts/accounts_provider.dart';
import 'package:aad/domain/providers/transactions/today_transactions_provider.dart';
import 'package:aad/domain/providers/transactions/transactions_provider.dart';
import 'package:aad/domain/repository/category_repository_provider.dart';
import 'package:aad/domain/repository/transaction_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_actions_provider.g.dart';

@Riverpod(keepAlive: true)
class TransactionActions extends _$TransactionActions {
  @override
  FutureOr<void> build() {}

  Future<void> createTransaction({
    required String accountId,
    required String categoryId,
    required int amount,
    required DateTime date,
    String? comment,
  }) async {
    await ref.read(transactionRepositoryProvider).createTransaction(
      accountId: accountId,
      categoryId: categoryId,
      amount: amount,
      date: date,
      comment: comment,
    );
    _invalidate();
  }

  Future<void> editTransaction({
    required String id,
    required String categoryId,
    required int amount,
    required DateTime date,
    String? comment,
  }) async {
    await ref.read(transactionRepositoryProvider).editTransaction(
      id: id,
      categoryId: categoryId,
      amount: amount,
      date: date,
      comment: comment,
    );
    _invalidate();
  }

  /// Sets the account balance to [newBalance] by recording the difference as
  /// a transaction against the system 'Account balance' category.
  Future<void> adjustAccountBalance({
    required String accountId,
    required int newBalance,
  }) async {
    final repository = ref.read(transactionRepositoryProvider);
    // Re-read the balance here so a stale UI can't skew the adjustment.
    final currentBalance = await repository.getAccountBalance(accountId);
    final delta = newBalance - currentBalance;
    if (delta == 0) return;

    final category = await ref
        .read(categoryRepositoryProvider)
        .getAccountBalanceCategory(
          delta > 0 ? CategoryType.income : CategoryType.expense,
        );

    await repository.createTransaction(
      accountId: accountId,
      categoryId: category.id,
      amount: delta.abs(),
      date: DateTime.now(),
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
    // Transactions change account balances.
    ref.invalidate(accountsProvider);
  }
}
