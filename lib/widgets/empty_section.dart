import 'package:flutter/material.dart';

import 'package:aad/utils/app_theme.dart';

/// Placeholder shown in a section that has no items yet. Just dimmed,
/// secondary text with padding — callers supply the message via [text] and
/// wrap it in a Card or other container when the surrounding UI calls for one.
class EmptySection extends StatelessWidget {
  const EmptySection({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
