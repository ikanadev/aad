import 'package:flutter/material.dart';

import 'package:aad/domain/models/transaction_filters.dart';
import 'package:aad/utils/date_range_utils.dart';

class RangeNavigator extends StatelessWidget {
  const RangeNavigator({
    super.key,
    required this.filters,
    required this.onPrevious,
    required this.onNext,
  });

  final TransactionFilters filters;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final canGoNext =
        filters.to != null && filters.to!.isBefore(DateTime.now());

    return Row(
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Text(
            filters.from == null
                ? ''
                : dateRangeLabel(filters.rangeType, filters.from!),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: canGoNext ? onNext : null,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}
