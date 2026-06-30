// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionsList)
final transactionsListProvider = TransactionsListFamily._();

final class TransactionsListProvider
    extends $AsyncNotifierProvider<TransactionsList, TransactionListState> {
  TransactionsListProvider._({
    required TransactionsListFamily super.from,
    required TransactionFilters super.argument,
  }) : super(
         retry: null,
         name: r'transactionsListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionsListHash();

  @override
  String toString() {
    return r'transactionsListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TransactionsList create() => TransactionsList();

  @override
  bool operator ==(Object other) {
    return other is TransactionsListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionsListHash() => r'1fafc241c2e42d15de36193cb24044b7f66627c0';

final class TransactionsListFamily extends $Family
    with
        $ClassFamilyOverride<
          TransactionsList,
          AsyncValue<TransactionListState>,
          TransactionListState,
          FutureOr<TransactionListState>,
          TransactionFilters
        > {
  TransactionsListFamily._()
    : super(
        retry: null,
        name: r'transactionsListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransactionsListProvider call(TransactionFilters filters) =>
      TransactionsListProvider._(argument: filters, from: this);

  @override
  String toString() => r'transactionsListProvider';
}

abstract class _$TransactionsList extends $AsyncNotifier<TransactionListState> {
  late final _$args = ref.$arg as TransactionFilters;
  TransactionFilters get filters => _$args;

  FutureOr<TransactionListState> build(TransactionFilters filters);
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
    return element.handleCreate(ref, () => build(_$args));
  }
}
