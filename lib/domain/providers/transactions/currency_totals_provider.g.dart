// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_totals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currencyTotals)
final currencyTotalsProvider = CurrencyTotalsFamily._();

final class CurrencyTotalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          FutureOr<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $FutureProvider<Map<String, int>> {
  CurrencyTotalsProvider._({
    required CurrencyTotalsFamily super.from,
    required TransactionFilters super.argument,
  }) : super(
         retry: null,
         name: r'currencyTotalsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$currencyTotalsHash();

  @override
  String toString() {
    return r'currencyTotalsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, int>> create(Ref ref) {
    final argument = this.argument as TransactionFilters;
    return currencyTotals(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrencyTotalsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currencyTotalsHash() => r'd92c83bc98f955c1594e14f7b28500162b7f8154';

final class CurrencyTotalsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, int>>,
          TransactionFilters
        > {
  CurrencyTotalsFamily._()
    : super(
        retry: null,
        name: r'currencyTotalsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CurrencyTotalsProvider call(TransactionFilters filters) =>
      CurrencyTotalsProvider._(argument: filters, from: this);

  @override
  String toString() => r'currencyTotalsProvider';
}
