import 'package:aad/domain/models/account.dart';

class AccountDetails extends Account {
  final int balance; // cents, net (income - expenses)

  const AccountDetails({
    required super.id,
    required super.name,
    required super.currencyCode,
    required super.color,
    required super.isDefault,
    required this.balance,
  });

  factory AccountDetails.fromAccount(Account account, {required int balance}) {
    return AccountDetails(
      id: account.id,
      name: account.name,
      currencyCode: account.currencyCode,
      color: account.color,
      isDefault: account.isDefault,
      balance: balance,
    );
  }
}
