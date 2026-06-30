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
}
