import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/providers/categories/categories_provider.dart';
import 'package:aad/domain/providers/categories/category_actions_provider.dart';
import 'package:aad/screens/categories/widgets/category_form.dart';
import 'package:aad/widgets/error_section.dart';

class EditCategoryScreen extends ConsumerStatefulWidget {
  const EditCategoryScreen({super.key, required this.categoryId});

  final String categoryId;

  @override
  ConsumerState<EditCategoryScreen> createState() =>
      _EditCategoryScreenState();
}

class _EditCategoryScreenState extends ConsumerState<EditCategoryScreen> {
  bool _deleting = false;

  @override
  Widget build(BuildContext context) {
    final categoriesValue = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit category'),
        actions: [
          IconButton(
            tooltip: 'Remove category',
            onPressed: _deleting ? null : _confirmRemove,
            icon: _deleting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: categoriesValue.when(
        data: (categories) {
          final category = _findCategory(categories);
          if (category == null) {
            return const Center(child: Text('Category not found.'));
          }

          return CategoryForm(
            category: category,
            submitLabel: 'Save changes',
            onSubmit: (name, iconName, type, color) =>
                _save(name, iconName, type, color),
          );
        },
        error: (error, stackTrace) => Center(
          child: ErrorSection(text: 'Could not load category: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Category? _findCategory(List<Category> categories) {
    for (final category in categories) {
      if (category.id == widget.categoryId) return category;
    }
    return null;
  }

  Future<void> _save(
    String name,
    String iconName,
    CategoryType type,
    String color,
  ) async {
    await ref
        .read(categoryActionsProvider.notifier)
        .updateCategory(
          id: widget.categoryId,
          name: name,
          iconName: iconName,
          type: type,
          color: color,
        );

    if (mounted) context.pop();
  }

  Future<void> _confirmRemove() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove category?'),
        content: const Text(
          'Are you sure you want to remove this category? Related transactions will be lost.',
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

    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);

    try {
      await ref
          .read(categoryActionsProvider.notifier)
          .deleteCategory(id: widget.categoryId);

      if (mounted) context.pop();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not remove category: $error')),
        );
        setState(() => _deleting = false);
      }
    }
  }
}
