import 'package:flutter/material.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/utils/app_theme.dart';
import 'package:aad/widgets/app_icon.dart';

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
    final color = category.appColor;
    final icon = AppIcons.tryParse(category.iconName);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: isDragging ? 8 : 1,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.container,
                child: icon == null
                    ? Icon(Icons.category_outlined, color: color.fill)
                    : AppIcon(icon: icon, size: 26),
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
