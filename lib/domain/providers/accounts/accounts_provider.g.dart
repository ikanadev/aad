// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accounts)
final accountsProvider = AccountsProvider._();

final class AccountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Account>>,
          List<Account>,
          FutureOr<List<Account>>
        >
    with $FutureModifier<List<Account>>, $FutureProvider<List<Account>> {
  AccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountsHash();

  @$internal
  @override
  $FutureProviderElement<List<Account>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Account>> create(Ref ref) {
    return accounts(ref);
  }
}

String _$accountsHash() => r'410db82e5ae9798b714fe9a5f4a0b77ebdf23876';
