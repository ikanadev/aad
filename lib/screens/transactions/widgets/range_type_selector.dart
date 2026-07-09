import 'package:flutter/material.dart';

import 'package:aad/domain/models/transaction_filters.dart';

class RangeTypeSelector extends StatelessWidget {
  const RangeTypeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final DateRangeType selected;
  final ValueChanged<DateRangeType> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final type in DateRangeType.values) ...[
          _RangeTypeButton(
            type: type,
            isSelected: type == selected,
            onTap: () => onSelected(type),
          ),
          if (type != DateRangeType.values.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _RangeTypeButton extends StatelessWidget {
  const _RangeTypeButton({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final DateRangeType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isSelected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    return Material(
      color: isSelected
          ? colorScheme.primaryContainer
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isSelected ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 64,
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_icon, size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                _label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w600 : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData get _icon => switch (type) {
    DateRangeType.year => Icons.calendar_month_outlined,
    DateRangeType.month => Icons.calendar_view_month_outlined,
    DateRangeType.week => Icons.date_range_outlined,
    DateRangeType.date => Icons.today_outlined,
  };

  String get _label => switch (type) {
    DateRangeType.year => 'Year',
    DateRangeType.month => 'Month',
    DateRangeType.week => 'Week',
    DateRangeType.date => 'Date',
  };
}
