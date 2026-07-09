import 'package:flutter/material.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/screens/categories/widgets/category_card.dart';

class ReorderableCategoryGridView extends StatefulWidget {
  const ReorderableCategoryGridView({
    super.key,
    required this.categories,
    required this.onReorder,
    required this.onCategoryTap,
  });

  final List<Category> categories;
  final ValueChanged<List<Category>> onReorder;
  final ValueChanged<Category> onCategoryTap;

  @override
  State<ReorderableCategoryGridView> createState() =>
      _ReorderableCategoryGridViewState();
}

class _ReorderableCategoryGridViewState
    extends State<ReorderableCategoryGridView> {
  String? _draggingId;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 900
        ? 5
        : width >= 650
        ? 4
        : width >= 420
        ? 3
        : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        final category = widget.categories[index];
        return DragTarget<Category>(
          key: ValueKey(category.id),
          onWillAcceptWithDetails: (details) => details.data.id != category.id,
          onAcceptWithDetails: (details) => _moveCategory(details.data, index),
          builder: (context, candidateData, rejectedData) {
            final isTarget = candidateData.isNotEmpty;
            return LongPressDraggable<Category>(
              data: category,
              onDragStarted: () => setState(() => _draggingId = category.id),
              onDragEnd: (_) => setState(() => _draggingId = null),
              onDraggableCanceled: (_, _) => setState(() => _draggingId = null),
              feedback: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 150,
                  height: 135,
                  child: CategoryCard(category: category, isDragging: true),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.35,
                child: CategoryCard(category: category),
              ),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 150),
                scale: isTarget ? 0.95 : 1,
                child: CategoryCard(
                  category: category,
                  isDragging: _draggingId == category.id,
                  onTap: () => widget.onCategoryTap(category),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _moveCategory(Category draggedCategory, int targetIndex) {
    final reordered = [...widget.categories];
    final oldIndex = reordered.indexWhere(
      (category) => category.id == draggedCategory.id,
    );
    if (oldIndex == -1 || oldIndex == targetIndex) return;
    final item = reordered.removeAt(oldIndex);
    final adjustedTargetIndex = oldIndex < targetIndex
        ? targetIndex - 1
        : targetIndex;
    reordered.insert(adjustedTargetIndex, item);
    widget.onReorder(reordered);
    setState(() => _draggingId = null);
  }
}
