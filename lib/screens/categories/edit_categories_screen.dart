import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/providers/categories/categories_provider.dart';
import 'package:aad/screens/categories/widgets/category_bottom_sheet.dart';
import 'package:aad/screens/categories/widgets/category_section_title.dart';
import 'package:aad/screens/categories/widgets/editable_category_tile.dart';

class EditCategoriesScreen extends ConsumerWidget {
  const EditCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesValue = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategorySheet(context, ref),
        child: const Icon(Icons.add),
      ),
      body: categoriesValue.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories yet.'));
          }

          final expenses = categories
              .where((category) => category.type == CategoryType.expense)
              .toList();
          final incomes = categories
              .where((category) => category.type == CategoryType.income)
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              CategorySectionTitle(
                title: 'Expenses',
                color: Colors.red.shade600,
              ),
              for (final category in expenses)
                EditableCategoryTile(
                  category: category,
                  onTap: () =>
                      _showCategorySheet(context, ref, category: category),
                ),
              const SizedBox(height: 16),
              CategorySectionTitle(
                title: 'Incomes',
                color: Colors.green.shade600,
              ),
              for (final category in incomes)
                EditableCategoryTile(
                  category: category,
                  onTap: () =>
                      _showCategorySheet(context, ref, category: category),
                ),
            ],
          );
        },
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Could not load categories: $error'),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _showCategorySheet(
    BuildContext context,
    WidgetRef ref, {
    Category? category,
  }) async {
    final result = await showModalBottomSheet<CategoryBottomSheetResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CategoryBottomSheet(category: category),
    );

    if (result == null || !context.mounted) return;

    if (result.deleteRequested && category != null) {
      await _confirmDelete(context, ref, category);
      return;
    }

    if (category == null) {
      await ref
          .read(categoriesProvider.notifier)
          .createCategory(
            name: result.name,
            iconName: result.iconName,
            type: result.type,
            color: result.color,
          );
      return;
    }

    await ref
        .read(categoriesProvider.notifier)
        .updateCategory(
          id: category.id,
          name: result.name,
          iconName: result.iconName,
          type: result.type,
          color: result.color,
        );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove category?'),
        content: Text(
          'Are you sure you want to remove ${category.name} category? N transactions will be lost',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ref.read(categoriesProvider.notifier).deleteCategory(id: category.id);
  }
}
