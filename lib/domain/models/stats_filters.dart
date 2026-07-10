import 'package:flutter/foundation.dart';

class StatsFilters {
  final int year;

  /// null or empty means "all accounts".
  final List<String>? accountIds;

  /// null or empty means "all categories".
  final List<String>? categoryIds;

  const StatsFilters({required this.year, this.accountIds, this.categoryIds});

  DateTime get from => DateTime(year);

  DateTime get to => DateTime(year, 12, 31, 23, 59, 59, 999);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StatsFilters &&
            other.year == year &&
            listEquals(other.accountIds, accountIds) &&
            listEquals(other.categoryIds, categoryIds);
  }

  @override
  int get hashCode => Object.hash(
    year,
    Object.hashAll(accountIds ?? const []),
    Object.hashAll(categoryIds ?? const []),
  );
}
