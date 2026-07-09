import 'package:flutter/foundation.dart';

enum TransactionSortField { date, amount }

enum SortDirection { asc, desc }

enum DateRangeType { year, month, week, date }

class TransactionFilters {
  final List<String>? accountIds;
  final List<String>? categoryIds;
  final DateRangeType rangeType;
  final DateTime? from;
  final DateTime? to;
  final TransactionSortField sortBy;
  final SortDirection direction;

  const TransactionFilters({
    this.accountIds,
    this.categoryIds,
    this.rangeType = DateRangeType.date,
    this.from,
    this.to,
    this.sortBy = TransactionSortField.date,
    this.direction = SortDirection.desc,
  });

  TransactionFilters copyWith({
    List<String>? accountIds,
    List<String>? categoryIds,
    DateRangeType? rangeType,
    DateTime? from,
    DateTime? to,
    TransactionSortField? sortBy,
    SortDirection? direction,
  }) {
    return TransactionFilters(
      accountIds: accountIds ?? this.accountIds,
      categoryIds: categoryIds ?? this.categoryIds,
      rangeType: rangeType ?? this.rangeType,
      from: from ?? this.from,
      to: to ?? this.to,
      sortBy: sortBy ?? this.sortBy,
      direction: direction ?? this.direction,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TransactionFilters &&
            listEquals(other.accountIds, accountIds) &&
            listEquals(other.categoryIds, categoryIds) &&
            other.rangeType == rangeType &&
            other.from == from &&
            other.to == to &&
            other.sortBy == sortBy &&
            other.direction == direction;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(accountIds ?? const []),
    Object.hashAll(categoryIds ?? const []),
    rangeType,
    from,
    to,
    sortBy,
    direction,
  );
}
