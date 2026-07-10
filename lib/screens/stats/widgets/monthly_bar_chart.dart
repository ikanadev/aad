import 'package:flutter/material.dart';

import 'package:aad/domain/models/year_stats.dart';
import 'package:aad/utils/currency_colors.dart';

/// Grid lines and Y-axis labels are painted; the 12 bars are real widgets so
/// each month gets native tap handling.
class MonthlyBarChart extends StatelessWidget {
  const MonthlyBarChart({
    super.key,
    required this.stats,
    required this.selectedMonth,
    required this.onMonthTap,
  });

  final YearStats stats;
  final int? selectedMonth;
  final ValueChanged<int> onMonthTap;

  static const _plotHeight = 180.0;
  static const _labelHeight = 20.0;
  static const _gutterWidth = 44.0;
  static const _monthLabels = [
    'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D', //
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthTotals = stats.monthTotals;
    final axisMax = stats.axisMax;
    final now = DateTime.now();

    return SizedBox(
      height: _plotHeight + _labelHeight,
      child: CustomPaint(
        painter: _GridPainter(
          axisMax: axisMax,
          gutterWidth: _gutterWidth,
          plotHeight: _plotHeight,
          lineColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          baselineColor: theme.colorScheme.outlineVariant,
          labelStyle: theme.textTheme.labelSmall!.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: _gutterWidth),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var month = 1; month <= 12; month++)
                Expanded(
                  child: _MonthCell(
                    label: _monthLabels[month - 1],
                    totals: monthTotals[month],
                    currencyOrder: stats.currencies,
                    axisMax: axisMax,
                    plotHeight: _plotHeight,
                    labelHeight: _labelHeight,
                    isSelected: selectedMonth == month,
                    isDimmed: selectedMonth != null && selectedMonth != month,
                    isFuture:
                        stats.year == now.year && month > now.month ||
                        stats.year > now.year,
                    onTap: () => onMonthTap(month),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthCell extends StatelessWidget {
  const _MonthCell({
    required this.label,
    required this.totals,
    required this.currencyOrder,
    required this.axisMax,
    required this.plotHeight,
    required this.labelHeight,
    required this.isSelected,
    required this.isDimmed,
    required this.isFuture,
    required this.onTap,
  });

  final String label;
  final Map<String, int>? totals;
  final List<String> currencyOrder;
  final int axisMax;
  final double plotHeight;
  final double labelHeight;
  final bool isSelected;
  final bool isDimmed;
  final bool isFuture;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Top-to-bottom column: last currency first so the first one sits on the
    // baseline; only the topmost visible segment gets rounded corners.
    final visible = [
      for (final currency in currencyOrder)
        if ((totals?[currency] ?? 0) > 0) currency,
    ];

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isFuture ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.08)
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Opacity(
                  opacity: isDimmed ? 0.35 : 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final currency in visible.reversed)
                        Container(
                          height: totals![currency]! / axisMax * plotHeight,
                          decoration: BoxDecoration(
                            color: currencyColor(currency),
                            borderRadius: currency == visible.last
                                ? const BorderRadius.vertical(
                                    top: Radius.circular(3),
                                  )
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: labelHeight,
              child: Center(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isFuture
                        ? theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.4,
                          )
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w700 : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({
    required this.axisMax,
    required this.gutterWidth,
    required this.plotHeight,
    required this.lineColor,
    required this.baselineColor,
    required this.labelStyle,
  });

  final int axisMax;
  final double gutterWidth;
  final double plotHeight;
  final Color lineColor;
  final Color baselineColor;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;
    final baselinePaint = Paint()
      ..color = baselineColor
      ..strokeWidth = 1;

    final steps = axisMax ~/ YearStats.centsPerAxisStep;
    for (var step = 0; step <= steps; step++) {
      final value = step * YearStats.centsPerAxisStep;
      final y = plotHeight - value / axisMax * plotHeight;

      canvas.drawLine(
        Offset(gutterWidth, y),
        Offset(size.width, y),
        step == 0 ? baselinePaint : linePaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(text: '${value ~/ 100}', style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(
          gutterWidth - textPainter.width - 6,
          (y - textPainter.height / 2).clamp(0, plotHeight),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) {
    return oldDelegate.axisMax != axisMax ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.baselineColor != baselineColor ||
        oldDelegate.labelStyle != labelStyle;
  }
}
