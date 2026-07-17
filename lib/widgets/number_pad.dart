import 'package:flutter/material.dart';

import 'package:aad/utils/app_theme.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.onNumberPress,
    required this.onDecimalPress,
    required this.onRemove,
    required this.onSubmit,
  });

  final void Function(int number) onNumberPress;
  final VoidCallback onDecimalPress;
  final VoidCallback onRemove;
  final VoidCallback onSubmit;

  static const _rowHeight = 64.0;
  static const _gap = AppSpacing.s8;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _rowHeight * 4 + _gap * 3,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                for (final row in const [
                  [1, 2, 3],
                  [4, 5, 6],
                  [7, 8, 9],
                ]) ...[
                  Expanded(
                    child: Row(
                      children: [
                        for (final number in row) ...[
                          if (number != row.first) const SizedBox(width: _gap),
                          Expanded(
                            child: _PadButton(
                              onPressed: () => onNumberPress(number),
                              child: Text('$number'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: _gap),
                ],
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _PadButton(
                          onPressed: () => onNumberPress(0),
                          child: const Text('0'),
                        ),
                      ),
                      const SizedBox(width: _gap),
                      Expanded(
                        child: _PadButton(
                          onPressed: onDecimalPress,
                          child: const Text('.'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: _gap),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _PadButton(
                    onPressed: onRemove,
                    child: const Icon(Icons.backspace_outlined),
                  ),
                ),
                const SizedBox(height: _gap),
                Expanded(
                  flex: 3,
                  child: _PadButton(
                    filled: true,
                    onPressed: onSubmit,
                    child: const Icon(Icons.check),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PadButton extends StatelessWidget {
  const _PadButton({
    required this.onPressed,
    required this.child,
    this.filled = false,
  });

  final VoidCallback onPressed;
  final Widget child;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final style = ButtonStyle(
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      textStyle: WidgetStatePropertyAll(
        Theme.of(context).textTheme.titleLarge,
      ),
    );

    return SizedBox.expand(
      child: filled
          ? FilledButton(onPressed: onPressed, style: style, child: child)
          : FilledButton.tonal(onPressed: onPressed, style: style, child: child),
    );
  }
}
