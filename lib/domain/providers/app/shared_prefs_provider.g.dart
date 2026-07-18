// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_prefs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPrefs)
final sharedPrefsProvider = SharedPrefsProvider._();

final class SharedPrefsProvider
    extends
        $FunctionalProvider<
          SharedPreferencesWithCache,
          SharedPreferencesWithCache,
          SharedPreferencesWithCache
        >
    with $Provider<SharedPreferencesWithCache> {
  SharedPrefsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPrefsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPrefsHash();

  @$internal
  @override
  $ProviderElement<SharedPreferencesWithCache> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferencesWithCache create(Ref ref) {
    return sharedPrefs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferencesWithCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferencesWithCache>(value),
    );
  }
}

String _$sharedPrefsHash() => r'6fce3fb0c29b5dcdaed5ee7350f198bbb8c798b7';
