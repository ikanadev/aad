// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionsList)
final transactionsListProvider = TransactionsListProvider._();

final class TransactionsListProvider
    extends $AsyncNotifierProvider<TransactionsList, TransactionListState> {
  TransactionsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionsListHash();

  @$internal
  @override
  TransactionsList create() => TransactionsList();
}

String _$transactionsListHash() => r'9e016e34741f2995726037fa305735b407927931';

abstract class _$TransactionsList extends $AsyncNotifier<TransactionListState> {
  FutureOr<TransactionListState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<TransactionListState>, TransactionListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<TransactionListState>,
                TransactionListState
              >,
              AsyncValue<TransactionListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
