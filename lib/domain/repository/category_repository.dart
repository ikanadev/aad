import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:aad/db/database.dart';
import 'package:aad/domain/models/category.dart';

class CategoryRepository {
  CategoryRepository(this._database);

  final AppDatabase _database;
  final Uuid _uuid = const Uuid();

  Future<List<Category>> listCategories({
    CategoryType? type,
    bool includeSystem = false,
  }) async {
    final query = _database.select(_database.dbCategories)
      ..where((category) => category.isDeleted.equals(false));

    if (!includeSystem) {
      query.where((category) => category.isSystem.equals(false));
    }
    if (type != null) {
      query.where((category) => category.type.equals(type.dbValue));
    }

    query.orderBy([
      (category) => OrderingTerm.asc(category.sortOrder),
      (category) => OrderingTerm.asc(category.name),
    ]);

    final rows = await query.get();
    return rows.map(Category.fromDB).toList();
  }

  Future<String> createCategory({
    required String name,
    required String iconName,
    required CategoryType type,
    required String color,
  }) async {
    final id = _uuid.v4();
    final sortOrder = await _nextSortOrder(type);

    await _database
        .into(_database.dbCategories)
        .insert(
          DbCategoriesCompanion.insert(
            id: id,
            name: name.trim(),
            iconName: iconName,
            type: type.dbValue,
            color: color,
            sortOrder: Value(sortOrder),
            isSystem: const Value(false),
            serverVersion: const Value(0),
            isDirty: const Value(true),
            isDeleted: const Value(false),
          ),
        );

    return id;
  }

  Future<void> updateCategory({
    required String id,
    required String name,
    required String iconName,
    required CategoryType type,
    required String color,
  }) async {
    final category = await (_database.select(
      _database.dbCategories,
    )..where((category) => category.id.equals(id))).getSingle();
    final movedType = category.type != type.dbValue;

    await (_database.update(
      _database.dbCategories,
    )..where((category) => category.id.equals(id))).write(
      DbCategoriesCompanion(
        name: Value(name.trim()),
        iconName: Value(iconName),
        type: Value(type.dbValue),
        color: Value(color),
        sortOrder: movedType
            ? Value(await _nextSortOrder(type))
            : const Value.absent(),
        isDirty: const Value(true),
      ),
    );
  }

  Future<void> deleteCategory({required String id}) async {
    await (_database.update(
      _database.dbCategories,
    )..where((category) => category.id.equals(id))).write(
      const DbCategoriesCompanion(isDeleted: Value(true), isDirty: Value(true)),
    );
  }

  Future<void> reorderCategories({
    required CategoryType type,
    required List<Category> categories,
  }) async {
    await _database.batch((batch) {
      for (var index = 0; index < categories.length; index++) {
        batch.update(
          _database.dbCategories,
          DbCategoriesCompanion(
            sortOrder: Value(index),
            isDirty: const Value(true),
          ),
          where: (category) => category.id.equals(categories[index].id),
        );
      }
    });
  }

  Future<int> _nextSortOrder(CategoryType type) async {
    final categories = await listCategories(type: type);
    if (categories.isEmpty) return 0;
    return categories
            .map((category) => category.sortOrder)
            .reduce((a, b) => a > b ? a : b) +
        1;
  }
}
