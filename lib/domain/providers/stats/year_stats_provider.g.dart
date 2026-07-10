// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(yearStats)
final yearStatsProvider = YearStatsProvider._();

final class YearStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<YearStats>,
          YearStats,
          FutureOr<YearStats>
        >
    with $FutureModifier<YearStats>, $FutureProvider<YearStats> {
  YearStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'yearStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$yearStatsHash();

  @$internal
  @override
  $FutureProviderElement<YearStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<YearStats> create(Ref ref) {
    return yearStats(ref);
  }
}

String _$yearStatsHash() => r'7fac88efb124cdc460256b0dbe22e8f76f30b030';
