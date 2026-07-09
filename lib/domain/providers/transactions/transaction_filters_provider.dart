import 'package:aad/domain/models/transaction_filters.dart';
import 'package:aad/utils/date_range_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_filters_provider.g.dart';

@riverpod
class TransactionFiltersNotifier extends _$TransactionFiltersNotifier {
  @override
  TransactionFilters build() => _withRange(
    const TransactionFilters(),
    DateRangeType.date,
    DateTime.now(),
  );

  void update(TransactionFilters filters) => state = filters;

  void reset() => state = build();

  void setRangeType(DateRangeType type) {
    // Re-anchor to today when the current range contains it, so e.g. going
    // from "This week" to date lands on "Today" instead of Monday.
    final now = DateTime.now();
    final from = state.from;
    final to = state.to;
    final containsToday =
        from != null && to != null && !now.isBefore(from) && !now.isAfter(to);
    state = _withRange(state, type, containsToday ? now : from ?? now);
  }

  void nextRange() => _shiftRange(1);

  void previousRange() => _shiftRange(-1);

  void _shiftRange(int delta) {
    final anchor = shiftAnchor(
      state.rangeType,
      state.from ?? DateTime.now(),
      delta,
    );
    state = _withRange(state, state.rangeType, anchor);
  }

  TransactionFilters _withRange(
    TransactionFilters filters,
    DateRangeType type,
    DateTime anchor,
  ) {
    final range = dateRangeFor(type, anchor);
    return filters.copyWith(rangeType: type, from: range.from, to: range.to);
  }
}
