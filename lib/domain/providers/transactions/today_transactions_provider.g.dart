// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(todayTransactions)
final todayTransactionsProvider = TodayTransactionsProvider._();

final class TodayTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionDetails>>,
          List<TransactionDetails>,
          FutureOr<List<TransactionDetails>>
        >
    with
        $FutureModifier<List<TransactionDetails>>,
        $FutureProvider<List<TransactionDetails>> {
  TodayTransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayTransactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayTransactionsHash();

  @$internal
  @override
  $FutureProviderElement<List<TransactionDetails>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TransactionDetails>> create(Ref ref) {
    return todayTransactions(ref);
  }
}

String _$todayTransactionsHash() => r'08f9ac562a17e8bf37aff86d4ccbd43751ca3dac';
