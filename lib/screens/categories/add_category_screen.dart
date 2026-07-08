import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/providers/categories/category_actions_provider.dart';
import 'package:aad/screens/categories/widgets/category_form.dart';

class AddCategoryScreen extends ConsumerWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add category')),
      body: CategoryForm(
        submitLabel: 'Create category',
        onSubmit: (name, iconName, type, color) =>
            _create(context, ref, name, iconName, type, color),
      ),
    );
  }

  Future<void> _create(
    BuildContext context,
    WidgetRef ref,
    String name,
    String iconName,
    CategoryType type,
    String color,
  ) async {
    await ref
        .read(categoryActionsProvider.notifier)
        .createCategory(name: name, iconName: iconName, type: type, color: color);

    if (context.mounted) context.pop();
  }
}
