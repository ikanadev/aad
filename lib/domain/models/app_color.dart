import 'package:flutter/material.dart';

/// A named color family shared by categories and accounts.
///
/// The DB stores [name], never a hex value, so the rendered tones can be
/// retuned without touching data. Each family carries two tones validated
/// against a dark surface: [fill] for icons, bars and swatches (>= 3:1 on
/// #121212) and [text] for colored text (>= 4.5:1 on #121212).
class AppColor {
  final String name;
  final Color fill;
  final Color text;

  const AppColor({required this.name, required this.fill, required this.text});

  /// Soft background for icon circles and chips.
  Color get container => fill.withValues(alpha: 0.18);

  String get label => name[0].toUpperCase() + name.substring(1);

  /// Falls back to the first color so an unknown stored name (e.g. from a
  /// newer client after sync) still renders.
  static AppColor byName(String name) {
    return appColors.firstWhere(
      (color) => color.name == name,
      orElse: () => appColors.first,
    );
  }
}

/// Semantic money colors: positive/income and negative/expense amounts.
/// Match the system balance-adjustment categories seeded in database.dart.
final incomeColor = AppColor.byName('emerald');
final expenseColor = AppColor.byName('rose');

const appColors = [
  AppColor(name: 'rose', fill: Color(0xFFF43F5E), text: Color(0xFFFB7185)),
  AppColor(name: 'orange', fill: Color(0xFFEA580C), text: Color(0xFFFB923C)),
  AppColor(name: 'amber', fill: Color(0xFFD97706), text: Color(0xFFFBBF24)),
  AppColor(name: 'lime', fill: Color(0xFF65A30D), text: Color(0xFFA3E635)),
  AppColor(name: 'emerald', fill: Color(0xFF059669), text: Color(0xFF34D399)),
  AppColor(name: 'teal', fill: Color(0xFF0D9488), text: Color(0xFF2DD4BF)),
  AppColor(name: 'cyan', fill: Color(0xFF0891B2), text: Color(0xFF22D3EE)),
  AppColor(name: 'blue', fill: Color(0xFF3B82F6), text: Color(0xFF60A5FA)),
  AppColor(name: 'indigo', fill: Color(0xFF6366F1), text: Color(0xFF818CF8)),
  AppColor(name: 'violet', fill: Color(0xFF8B5CF6), text: Color(0xFFA78BFA)),
  AppColor(name: 'fuchsia', fill: Color(0xFFD946EF), text: Color(0xFFE879F9)),
  AppColor(name: 'pink', fill: Color(0xFFEC4899), text: Color(0xFFF472B6)),
];
