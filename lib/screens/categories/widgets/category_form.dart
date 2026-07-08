import 'package:flutter/material.dart';

import 'package:aad/domain/models/category.dart';
import 'package:aad/domain/models/category_color.dart';
import 'package:aad/widgets/app_icon.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({
    super.key,
    this.category,
    required this.submitLabel,
    required this.onSubmit,
  });

  final Category? category;
  final String submitLabel;
  final Future<void> Function(
    String name,
    String iconName,
    CategoryType type,
    String color,
  )
  onSubmit;

  bool get isEditing => category != null;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late AppIcons _icon;
  late CategoryType _type;
  late String _color;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _icon =
        AppIcons.tryParse(widget.category?.iconName ?? '') ??
        AppIcons.values.first;
    _type = widget.category?.type ?? CategoryType.expense;
    _color = widget.category?.color ?? categoryColors.first.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_error != null) ...[
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter a category name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SwatchPickerField(
                label: 'Icon',
                onTap: _pickIcon,
                child: AppIcon(icon: _icon, size: 28),
              ),
              const SizedBox(width: 16),
              _SwatchPickerField(
                label: 'Color',
                onTap: _pickColor,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: categoryColorFromString(_color),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _submit,
            child: _saving
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.submitLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _pickIcon() async {
    final selected = await showDialog<AppIcons>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose an icon'),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: AppIcons.values.length,
            itemBuilder: (context, index) {
              final icon = AppIcons.values[index];
              final selected = icon == _icon;
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => Navigator.of(context).pop(icon),
                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Center(child: AppIcon(icon: icon, size: 28)),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selected != null) setState(() => _icon = selected);
  }

  Future<void> _pickColor() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Choose a color'),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final color in categoryColors)
                  Tooltip(
                    message: color.name,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => Navigator.of(context).pop(color.value),
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
          ),
          const SizedBox(height: 12),
        ],
      ),
    );

    if (selected != null) setState(() => _color = selected);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await widget.onSubmit(
        _nameController.text.trim(),
        _icon.name,
        _type,
        _color,
      );
    } catch (error) {
      if (mounted) setState(() => _error = 'Could not save category: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _SwatchPickerField extends StatelessWidget {
  const _SwatchPickerField({
    required this.label,
    required this.onTap,
    required this.child,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: child),
          ),
        ),
      ],
    );
  }
}
