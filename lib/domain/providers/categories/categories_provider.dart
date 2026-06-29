import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/repository/category_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_provider.g.dart';

@riverpod
class Categories extends _$Categories {
  @override
  Future<List<Category>> build() async {
    final categoryRepository = ref.watch(categoryRepositoryProvider);
    return categoryRepository.listCategories();
  }

  Future<void> createCategory({
    required String name,
    required String iconName,
    required CategoryType type,
    required String color,
  }) async {
    final categoryRepository = ref.read(categoryRepositoryProvider);
    await categoryRepository.createCategory(
      name: name,
      iconName: iconName,
      type: type,
      color: color,
    );
    ref.invalidateSelf();
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String iconName,
    required CategoryType type,
    required String color,
  }) async {
    final categoryRepository = ref.read(categoryRepositoryProvider);
    await categoryRepository.updateCategory(
      id: id,
      name: name,
      iconName: iconName,
      type: type,
      color: color,
    );
    ref.invalidateSelf();
  }

  Future<void> deleteCategory({required String id}) async {
    final categoryRepository = ref.read(categoryRepositoryProvider);
    await categoryRepository.deleteCategory(id: id);
    ref.invalidateSelf();
  }

  Future<void> reorderCategories({
    required CategoryType type,
    required List<Category> categories,
  }) async {
    state = AsyncValue.data(categories);
    final categoryRepository = ref.read(categoryRepositoryProvider);
    await categoryRepository.reorderCategories(
      type: type,
      categories: categories,
    );
    ref.invalidateSelf();
  }
}
