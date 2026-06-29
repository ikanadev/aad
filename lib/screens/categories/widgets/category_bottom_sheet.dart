import 'package:flutter/material.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/models/category_color.dart';

class CategoryBottomSheetResult {
  final String name;
  final String iconName;
  final CategoryType type;
  final String color;
  final bool deleteRequested;

  const CategoryBottomSheetResult({
    required this.name,
    required this.iconName,
    required this.type,
    required this.color,
    this.deleteRequested = false,
  });
}

class CategoryBottomSheet extends StatefulWidget {
  const CategoryBottomSheet({super.key, this.category});

  final Category? category;

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _iconNameController;
  late CategoryType _type;
  late String _color;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _iconNameController = TextEditingController(
      text: widget.category?.iconName ?? 'category',
    );
    _type = widget.category?.type ?? CategoryType.expense;
    _color = widget.category?.color ?? '#DC2626';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category == null ? 'Create category' : 'Edit category',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _iconNameController,
              decoration: const InputDecoration(
                labelText: 'Icon name',
                helperText: 'Temporary text input until icon picker is added.',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 12),
            SegmentedButton<CategoryType>(
              segments: const [
                ButtonSegment(
                  value: CategoryType.expense,
                  label: Text('Expense'),
                  icon: Icon(Icons.arrow_downward),
                ),
                ButtonSegment(
                  value: CategoryType.income,
                  label: Text('Income'),
                  icon: Icon(Icons.arrow_upward),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (selection) {
                setState(() => _type = selection.first);
              },
            ),
            const SizedBox(height: 16),
            Text('Color', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final color in categoryColors)
                  Tooltip(
                    message: '${color.name} 600',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => setState(() => _color = color.value),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.flutterColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _color == color.value
                                ? Theme.of(context).colorScheme.onSurface
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: _color == color.value
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (widget.category != null)
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(
                      CategoryBottomSheetResult(
                        name: _nameController.text,
                        iconName: _iconNameController.text,
                        type: _type,
                        color: _color,
                        deleteRequested: true,
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(
                    CategoryBottomSheetResult(
                      name: _nameController.text,
                      iconName: _iconNameController.text,
                      type: _type,
                      color: _color,
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
