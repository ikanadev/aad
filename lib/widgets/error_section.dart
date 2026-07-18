import 'package:flutter/material.dart';

import 'package:aad/utils/app_theme.dart';

/// Placeholder shown when a section fails to load. Renders [text] in the
/// destructive color with padding, and — when both [actionText] and [action]
/// are supplied — an underlined, pressable line beneath it for things like
/// "Retry" or "Show details".
class ErrorSection extends StatelessWidget {
  const ErrorSection({
    super.key,
    required this.text,
    this.actionText,
    this.action,
  });

  final String text;
  final String? actionText;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final showAction = actionText != null && action != null;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: errorColor),
            ),
            if (showAction) ...[
              const SizedBox(height: AppSpacing.s8),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: action,
                child: Text(
                  actionText!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: errorColor,
                    decoration: TextDecoration.underline,
                    decorationColor: errorColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
