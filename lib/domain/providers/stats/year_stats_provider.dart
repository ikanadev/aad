import 'package:aad/domain/models/year_stats.dart';
import 'package:aad/domain/providers/stats/stats_filters_provider.dart';
import 'package:aad/domain/repository/transaction_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'year_stats_provider.g.dart';

@riverpod
Future<YearStats> yearStats(Ref ref) {
  final filters = ref.watch(statsFiltersProvider);
  return ref.watch(transactionRepositoryProvider).getYearExpenseStats(filters);
}
