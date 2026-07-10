import 'package:flutter/material.dart';

class YearNavigator extends StatelessWidget {
  const YearNavigator({
    super.key,
    required this.year,
    required this.onPrevious,
    this.onNext,
  });

  final int year;
  final VoidCallback onPrevious;

  /// null disables the next button (already at the current year).
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Text(
            '$year',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
      ],
    );
  }
}
