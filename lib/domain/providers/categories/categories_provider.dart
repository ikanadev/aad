import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/repository/category_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'categories_provider.g.dart';

@riverpod
Future<List<Category>> categories(Ref ref) {
  return ref.watch(categoryRepositoryProvider).listCategories();
}
