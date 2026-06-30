// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_actions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionActions)
final transactionActionsProvider = TransactionActionsProvider._();

final class TransactionActionsProvider
    extends $AsyncNotifierProvider<TransactionActions, void> {
  TransactionActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionActionsHash();

  @$internal
  @override
  TransactionActions create() => TransactionActions();
}

String _$transactionActionsHash() =>
    r'7c5a5ec86c48501dcc72cfc95105273c115955c8';

abstract class _$TransactionActions extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
