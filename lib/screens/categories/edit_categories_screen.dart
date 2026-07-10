import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aad/domain/models/app_color.dart';
import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/providers/categories/categories_provider.dart';
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
        onPressed: () => context.push('/categories/new'),
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
                color: expenseColor.text,
              ),
              for (final category in expenses)
                EditableCategoryTile(
                  category: category,
                  onTap: () => context.push('/categories/${category.id}/edit'),
                ),
              const SizedBox(height: 16),
              CategorySectionTitle(
                title: 'Incomes',
                color: incomeColor.text,
              ),
              for (final category in incomes)
                EditableCategoryTile(
                  category: category,
                  onTap: () => context.push('/categories/${category.id}/edit'),
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
}
