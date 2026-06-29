import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/providers/categories/categories_provider.dart';
import 'package:aad/screens/categories/widgets/category_grid.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesValue = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            tooltip: 'Edit categories',
            onPressed: () => context.push('/categories/edit'),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Expenses', icon: Icon(Icons.arrow_downward)),
            Tab(text: 'Incomes', icon: Icon(Icons.arrow_upward)),
          ],
          indicatorColor: Colors.red.shade600,
          labelColor: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: categoriesValue.when(
        data: (categories) => TabBarView(
          controller: _tabController,
          children: [
            CategoryGrid(
              type: CategoryType.expense,
              accentColor: Colors.red.shade600,
              categories: categories
                  .where((category) => category.type == CategoryType.expense)
                  .toList(),
              onReorder: (reordered) => ref
                  .read(categoriesProvider.notifier)
                  .reorderCategories(
                    type: CategoryType.expense,
                    categories: reordered,
                  ),
            ),
            CategoryGrid(
              type: CategoryType.income,
              accentColor: Colors.green.shade600,
              categories: categories
                  .where((category) => category.type == CategoryType.income)
                  .toList(),
              onReorder: (reordered) => ref
                  .read(categoriesProvider.notifier)
                  .reorderCategories(
                    type: CategoryType.income,
                    categories: reordered,
                  ),
            ),
          ],
        ),
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
