import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/providers/categories/categories_provider.dart';
import 'package:aad/domain/repository/category_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_actions_provider.g.dart';

@riverpod
class CategoryActions extends _$CategoryActions {
  @override
  FutureOr<void> build() {}

  Future<void> createCategory({
    required String name,
    required String iconName,
    required CategoryType type,
    required String color,
  }) async {
    await ref.read(categoryRepositoryProvider).createCategory(
      name: name,
      iconName: iconName,
      type: type,
      color: color,
    );
    ref.invalidate(categoriesProvider);
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String iconName,
    required CategoryType type,
    required String color,
  }) async {
    await ref.read(categoryRepositoryProvider).updateCategory(
      id: id,
      name: name,
      iconName: iconName,
      type: type,
      color: color,
    );
    ref.invalidate(categoriesProvider);
  }

  Future<void> deleteCategory({required String id}) async {
    await ref.read(categoryRepositoryProvider).deleteCategory(id: id);
    ref.invalidate(categoriesProvider);
  }

  Future<void> reorderCategories({
    required CategoryType type,
    required List<Category> categories,
  }) async {
    await ref.read(categoryRepositoryProvider).reorderCategories(
      type: type,
      categories: categories,
    );
    ref.invalidate(categoriesProvider);
  }
}
