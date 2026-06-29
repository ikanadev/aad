import 'package:flutter/material.dart';
import 'package:drift/drift.dart';

import 'package:aad/db/database.dart';
import 'package:aad/domain/models/category_color.dart';

enum CategoryType {
  income,
  expense;

  String get dbValue => name;

  String get label => switch (this) {
    CategoryType.income => 'Income',
    CategoryType.expense => 'Expense',
  };

  static CategoryType fromDB(String value) {
    return CategoryType.values.firstWhere(
      (type) => type.dbValue == value,
      orElse: () => CategoryType.expense,
    );
  }
}

class Category {
  final String id;
  final String name;
  final String iconName;
  final CategoryType type;
  final String color;
  final int sortOrder;
  final bool isSystem;

  const Category({
    required this.id,
    required this.name,
    required this.iconName,
    required this.type,
    required this.color,
    required this.sortOrder,
    required this.isSystem,
  });

  Color get flutterColor => categoryColorFromString(color);

  factory Category.fromDB(DbCategory row) {
    return Category(
      id: row.id,
      name: row.name,
      iconName: row.iconName,
      type: CategoryType.fromDB(row.type),
      color: row.color,
      sortOrder: row.sortOrder,
      isSystem: row.isSystem,
    );
  }

  DbCategoriesCompanion toDB({bool isDirty = true}) {
    return DbCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      iconName: Value(iconName),
      type: Value(type.dbValue),
      color: Value(color),
      sortOrder: Value(sortOrder),
      isSystem: Value(isSystem),
      isDirty: Value(isDirty),
    );
  }
}
