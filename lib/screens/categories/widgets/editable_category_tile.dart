import 'package:flutter/material.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/widgets/app_icon.dart';

class EditableCategoryTile extends StatelessWidget {
  const EditableCategoryTile({
    super.key,
    required this.category,
    required this.onTap,
  });

  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = category.flutterColor;
    final icon = AppIcons.tryParse(category.iconName);
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.14),
          child: icon == null
              ? Icon(Icons.category_outlined, color: color)
              : AppIcon(icon: icon, size: 24),
        ),
        title: Text(category.name),
        subtitle: Text(category.type.label),
        trailing: const Icon(Icons.edit_outlined),
      ),
    );
  }
}
