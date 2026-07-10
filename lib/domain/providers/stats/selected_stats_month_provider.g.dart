// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_stats_month_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The month (1-12) picked on the chart, or null for the whole year.
/// Watching the filters resets the selection whenever year or filters change.

@ProviderFor(SelectedStatsMonth)
final selectedStatsMonthProvider = SelectedStatsMonthProvider._();

/// The month (1-12) picked on the chart, or null for the whole year.
/// Watching the filters resets the selection whenever year or filters change.
final class SelectedStatsMonthProvider
    extends $NotifierProvider<SelectedStatsMonth, int?> {
  /// The month (1-12) picked on the chart, or null for the whole year.
  /// Watching the filters resets the selection whenever year or filters change.
  SelectedStatsMonthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedStatsMonthProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedStatsMonthHash();

  @$internal
  @override
  SelectedStatsMonth create() => SelectedStatsMonth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$selectedStatsMonthHash() =>
    r'625581ec27897a512cccd2d08f93b95a06adf453';

/// The month (1-12) picked on the chart, or null for the whole year.
/// Watching the filters resets the selection whenever year or filters change.

abstract class _$SelectedStatsMonth extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
