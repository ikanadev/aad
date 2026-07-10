import 'package:aad/domain/providers/stats/stats_filters_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_stats_month_provider.g.dart';

/// The month (1-12) picked on the chart, or null for the whole year.
/// Watching the filters resets the selection whenever year or filters change.
@riverpod
class SelectedStatsMonth extends _$SelectedStatsMonth {
  @override
  int? build() {
    ref.watch(statsFiltersProvider);
    return null;
  }

  void toggle(int month) => state = state == month ? null : month;
}
