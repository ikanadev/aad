import 'package:aad/domain/models/stats_filters.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stats_filters_provider.g.dart';

@riverpod
class StatsFiltersNotifier extends _$StatsFiltersNotifier {
  @override
  StatsFilters build() => StatsFilters(year: DateTime.now().year);

  void previousYear() => _setYear(state.year - 1);

  void nextYear() {
    if (state.year >= DateTime.now().year) return;
    _setYear(state.year + 1);
  }

  void setAccountIds(List<String>? ids) {
    state = StatsFilters(
      year: state.year,
      accountIds: ids?.isEmpty == true ? null : ids,
      categoryIds: state.categoryIds,
    );
  }

  void setCategoryIds(List<String>? ids) {
    state = StatsFilters(
      year: state.year,
      accountIds: state.accountIds,
      categoryIds: ids?.isEmpty == true ? null : ids,
    );
  }

  void _setYear(int year) {
    state = StatsFilters(
      year: year,
      accountIds: state.accountIds,
      categoryIds: state.categoryIds,
    );
  }
}
