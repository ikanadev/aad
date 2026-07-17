import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aad/domain/models/app_color.dart';
import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/providers/accounts/default_account_provider.dart';
import 'package:aad/domain/providers/categories/categories_provider.dart';
import 'package:aad/domain/providers/categories/category_actions_provider.dart';
import 'package:aad/screens/categories/widgets/add_transaction_sheet.dart';
import 'package:aad/screens/categories/widgets/category_grid.dart';
import 'package:aad/utils/app_theme.dart';

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
          indicatorColor: expenseColor.fill,
          labelColor: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      body: categoriesValue.when(
        data: (categories) => TabBarView(
          controller: _tabController,
          children: [
            CategoryGrid(
              type: CategoryType.expense,
              accentColor: expenseColor.fill,
              categories: categories
                  .where((category) => category.type == CategoryType.expense)
                  .toList(),
              onReorder: (reordered) => ref
                  .read(categoryActionsProvider.notifier)
                  .reorderCategories(
                    type: CategoryType.expense,
                    categories: reordered,
                  ),
              onCategoryTap: _openAddTransaction,
            ),
            CategoryGrid(
              type: CategoryType.income,
              accentColor: incomeColor.fill,
              categories: categories
                  .where((category) => category.type == CategoryType.income)
                  .toList(),
              onReorder: (reordered) => ref
                  .read(categoryActionsProvider.notifier)
                  .reorderCategories(
                    type: CategoryType.income,
                    categories: reordered,
                  ),
              onCategoryTap: _openAddTransaction,
            ),
          ],
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s16),
            child: Text('Could not load categories: $error'),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> _openAddTransaction(Category category) async {
    final defaultAccount = await ref.read(defaultAccountProvider.future);
    if (!mounted) return;

    await showAddTransactionSheet(
      context,
      category: category,
      initialAccount: defaultAccount,
    );
  }
}
