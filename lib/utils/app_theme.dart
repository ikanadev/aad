import 'package:flutter/material.dart';

/// Design tokens for the app. Reference these instead of hardcoding magic
/// numbers so spacing and rounding stay consistent everywhere.
///
/// Colors are intentionally NOT tokens here: UI chrome pulls from
/// `Theme.of(context).colorScheme`, and user-chosen data colors come from the
/// AppColor palette. See CLAUDE.md.

/// Spacing scale. Named by their pixel value so the scale can grow without
/// renaming: 4 / 8 / 12 / 16 / 24 / 32 are the rhythm values this app uses.
abstract final class AppSpacing {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s24 = 24;
  static const double s32 = 32;
}

/// Corner-radius scale.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
}

/// Builds the app's [ThemeData] from a color scheme. Component-level defaults
/// (card shape, etc.) live here so call sites don't restyle them individually.
ThemeData buildAppTheme(ColorScheme colorScheme) {
  return ThemeData(
    colorScheme: colorScheme,
    cardTheme: const CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
  );
}
