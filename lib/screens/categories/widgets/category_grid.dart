import 'package:flutter/material.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/screens/categories/widgets/reorderable_category_grid_view.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    super.key,
    required this.type,
    required this.accentColor,
    required this.categories,
    required this.onReorder,
    required this.onCategoryTap,
  });

  final CategoryType type;
  final Color accentColor;
  final List<Category> categories;
  final ValueChanged<List<Category>> onReorder;
  final ValueChanged<Category> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No ${type == CategoryType.expense ? 'expense' : 'income'} categories yet.',
              style: TextStyle(color: accentColor),
            ),
          ),
        ),
      );
    }

    return ReorderableCategoryGridView(
      categories: categories,
      onReorder: onReorder,
      onCategoryTap: onCategoryTap,
    );
  }
}
