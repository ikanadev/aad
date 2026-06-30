import 'package:flutter/foundation.dart';

enum TransactionSortField { date, amount }

enum SortDirection { asc, desc }

class TransactionFilters {
  final List<String>? accountIds;
  final List<String>? categoryIds;
  final DateTime? from;
  final DateTime? to;
  final TransactionSortField sortBy;
  final SortDirection direction;

  const TransactionFilters({
    this.accountIds,
    this.categoryIds,
    this.from,
    this.to,
    this.sortBy = TransactionSortField.date,
    this.direction = SortDirection.desc,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TransactionFilters &&
            listEquals(other.accountIds, accountIds) &&
            listEquals(other.categoryIds, categoryIds) &&
            other.from == from &&
            other.to == to &&
            other.sortBy == sortBy &&
            other.direction == direction;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(accountIds ?? const []),
    Object.hashAll(categoryIds ?? const []),
    from,
    to,
    sortBy,
    direction,
  );
}
