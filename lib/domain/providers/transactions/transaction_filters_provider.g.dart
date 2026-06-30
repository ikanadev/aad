// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_filters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionFiltersNotifier)
final transactionFiltersProvider = TransactionFiltersNotifierProvider._();

final class TransactionFiltersNotifierProvider
    extends $NotifierProvider<TransactionFiltersNotifier, TransactionFilters> {
  TransactionFiltersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionFiltersNotifierHash();

  @$internal
  @override
  TransactionFiltersNotifier create() => TransactionFiltersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionFilters>(value),
    );
  }
}

String _$transactionFiltersNotifierHash() =>
    r'df2cdb249a88c33b5bda142711a44f0937dca73e';

abstract class _$TransactionFiltersNotifier
    extends $Notifier<TransactionFilters> {
  TransactionFilters build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TransactionFilters, TransactionFilters>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TransactionFilters, TransactionFilters>,
              TransactionFilters,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
