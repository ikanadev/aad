// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_actions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CategoryActions)
final categoryActionsProvider = CategoryActionsProvider._();

final class CategoryActionsProvider
    extends $AsyncNotifierProvider<CategoryActions, void> {
  CategoryActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryActionsHash();

  @$internal
  @override
  CategoryActions create() => CategoryActions();
}

String _$categoryActionsHash() => r'f1fb11336943adf2a1b58c758be416f139a1753e';

abstract class _$CategoryActions extends $AsyncNotifier<void> {
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
