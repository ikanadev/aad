// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_filters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StatsFiltersNotifier)
final statsFiltersProvider = StatsFiltersNotifierProvider._();

final class StatsFiltersNotifierProvider
    extends $NotifierProvider<StatsFiltersNotifier, StatsFilters> {
  StatsFiltersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsFiltersNotifierHash();

  @$internal
  @override
  StatsFiltersNotifier create() => StatsFiltersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StatsFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StatsFilters>(value),
    );
  }
}

String _$statsFiltersNotifierHash() =>
    r'4bda843821487a729624e92a70b066ef77ba6110';

abstract class _$StatsFiltersNotifier extends $Notifier<StatsFilters> {
  StatsFilters build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<StatsFilters, StatsFilters>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StatsFilters, StatsFilters>,
              StatsFilters,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
