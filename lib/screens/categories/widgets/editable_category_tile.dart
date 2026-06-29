import 'package:flutter/material.dart';

import 'package:aad/domain/models/category.dart';

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
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.14),
          child: Text(
            category.iconName.isEmpty
                ? '?'
                : category.iconName.characters.first.toUpperCase(),
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(category.name),
        subtitle: Text('${category.type.label} • ${category.iconName}'),
        trailing: const Icon(Icons.edit_outlined),
      ),
    );
  }
}
