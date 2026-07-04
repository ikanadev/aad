import 'package:aad/db/database.dart';
import 'package:aad/domain/models/account.dart';
import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/models/transaction.dart';

class TransactionDetails extends Transaction {
  final Account account;
  final Category category;

  const TransactionDetails({
    required super.id,
    required super.accountId,
    required super.categoryId,
    required super.amount,
    required super.date,
    super.comment,
    required this.account,
    required this.category,
  });

  factory TransactionDetails.fromDB({
    required DbTransaction transaction,
    required DbAccount account,
    required DbCategory category,
  }) {
    return TransactionDetails(
      id: transaction.id,
      accountId: transaction.accountId,
      categoryId: transaction.categoryId,
      amount: transaction.amount,
      date: transaction.date,
      comment: transaction.comment,
      account: Account.fromDB(account),
      category: Category.fromDB(category),
    );
  }
}
