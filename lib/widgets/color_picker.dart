import 'package:flutter/material.dart';

import 'package:aad/domain/models/app_color.dart';
import 'package:aad/utils/app_theme.dart';

/// Labeled 56x56 tappable box used by forms for icon/color swatches.
class SwatchPickerField extends StatelessWidget {
  const SwatchPickerField({
    super.key,
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
          borderRadius: AppRadius.smAll,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: AppRadius.smAll,
            ),
            child: Center(child: child),
          ),
        ),
      ],
    );
  }
}

/// Dialog over [appColors]; resolves to the chosen color, or null on cancel.
Future<AppColor?> showAppColorPicker(
  BuildContext context, {
  required String selectedName,
}) {
  return showDialog<AppColor>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Choose a color'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Wrap(
            spacing: AppSpacing.s12,
            runSpacing: AppSpacing.s12,
            children: [
              for (final color in appColors)
                Tooltip(
                  message: color.label,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => Navigator.of(context).pop(color),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color.fill,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedName == color.name
                              ? Theme.of(context).colorScheme.onSurface
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: selectedName == color.name
                          ? const Icon(Icons.check, color: Colors.white, size: 18)
                          : null,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
      ],
    ),
  );
}
