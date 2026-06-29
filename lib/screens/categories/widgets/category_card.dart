import 'package:flutter/material.dart';

import 'package:aad/domain/models/category.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    this.onTap,
    required this.category,
    this.isDragging = false,
  });

  final Category category;
  final VoidCallback? onTap;
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    final color = category.flutterColor;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isDragging ? 8 : 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.withValues(alpha: 0.14),
                child: Text(
                  category.iconName.isEmpty
                      ? '?'
                      : category.iconName.characters.first.toUpperCase(),
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
