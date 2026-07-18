import 'package:flutter/material.dart';

import 'package:aad/domain/models/app_color.dart';

/// Applies the semantic money colors ([incomeColor]/[expenseColor]) to an
/// already-resolved text style, keeping every other field (size, weight,
/// letter spacing…) intact. Reach for this instead of hand-writing
/// `copyWith(color: …)` at each call site so the green/red stays in one place.
///
/// ```dart
/// Text(amount, style: Theme.of(context).textTheme.titleMedium?.income);
/// ```
extension MoneyTextStyle on TextStyle {
  /// Positive / income amounts — green.
  TextStyle get income => copyWith(color: incomeColor.text);

  /// Negative / expense amounts — red.
  TextStyle get expense => copyWith(color: expenseColor.text);

  /// Colored by the sign of [amount]: [income] when `>= 0`, [expense] when
  /// negative.
  TextStyle bySign(num amount) => amount < 0 ? expense : income;
}
