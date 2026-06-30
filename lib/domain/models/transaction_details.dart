import 'package:aad/db/database.dart';
import 'package:aad/domain/models/account.dart';
import 'package:aad/domain/models/category.dart';

class TransactionDetails {
  final String id;
  final int amount; // cents, always positive
  final DateTime date;
  final String? comment;
  final Account account;
  final Category category;

  const TransactionDetails({
    required this.id,
    required this.amount,
    required this.date,
    this.comment,
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
      amount: transaction.amount,
      date: transaction.date,
      comment: transaction.comment,
      account: Account.fromDB(account),
      category: Category.fromDB(category),
    );
  }
}
