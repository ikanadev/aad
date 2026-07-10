import 'dart:ui';

/// Static per-currency colors for stats bars and badges.
/// Placeholder until currencies get a persisted color property.
const _currencyColors = <String, Color>{
  'USD': Color(0xFF3F51B5), // indigo
  'BOB': Color(0xFF009688), // teal
};

const _fallbackCurrencyColor = Color(0xFF9E9E9E); // gray

Color currencyColor(String code) =>
    _currencyColors[code.trim().toUpperCase()] ?? _fallbackCurrencyColor;
