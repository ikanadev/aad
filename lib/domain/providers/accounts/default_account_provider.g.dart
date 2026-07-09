// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(defaultAccount)
final defaultAccountProvider = DefaultAccountProvider._();

final class DefaultAccountProvider
    extends
        $FunctionalProvider<
          AsyncValue<AccountDetails?>,
          AccountDetails?,
          FutureOr<AccountDetails?>
        >
    with $FutureModifier<AccountDetails?>, $FutureProvider<AccountDetails?> {
  DefaultAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultAccountHash();

  @$internal
  @override
  $FutureProviderElement<AccountDetails?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AccountDetails?> create(Ref ref) {
    return defaultAccount(ref);
  }
}

String _$defaultAccountHash() => r'f79f6ca893967274e2348fa185f3b445775b7866';
