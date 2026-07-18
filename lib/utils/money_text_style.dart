import 'package:flutter/material.dart';

import 'package:aad/domain/models/app_color.dart';

/// Amount-formatting treatments layered onto an already-resolved text style,
/// keeping every other field (size, weight, letter spacing…) intact. Reach for
/// these instead of hand-writing `copyWith(...)` at each call site so the
/// monospace font and green/red colors stay in one place.
///
/// ```dart
/// Text(amount, style: Theme.of(context).textTheme.titleMedium?.income);
/// ```
extension MoneyTextStyle on TextStyle {
  /// Positive / income amounts — green, monospaced. The default for any money
  /// amount, since amounts are non-negative unless explicitly an expense.
  TextStyle get income =>
      copyWith(fontFamily: 'monospace', color: incomeColor.text);

  /// Negative / expense amounts — red, monospaced.
  TextStyle get expense =>
      copyWith(fontFamily: 'monospace', color: expenseColor.text);

  /// Colored by the sign of [amount]: [income] when `>= 0`, [expense] when
  /// negative.
  TextStyle bySign(num amount) => amount < 0 ? expense : income;
}
