import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A [ValueNotifier] that holds the current theme mode (light / dark).
///
/// Any widget can listen to this via [ValueListenableBuilder] and will
/// rebuild automatically when the value changes — no external state
/// management package needed for a single piece of global state.
final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

/// A small helper that groups the six colours we use throughout the app.
///
/// [Palette.of] picks light or dark based on the current [Brightness],
/// keeping colour lookups consistent everywhere.
class Palette {
  final Color bg, card, text, sub, accent, line;
  const Palette(this.bg, this.card, this.text, this.sub, this.accent, this.line);

  static const light = Palette(
    Color(0xFFFBF6EE),
    Color(0xFFFFFFFF),
    Color(0xFF2B1B14),
    Color(0xFF7A6558),
    Color(0xFFB5502D),
    Color(0xFFE6D9C8),
  );

  static const dark = Palette(
    Color(0xFF1A1411),
    Color(0xFF261D18),
    Color(0xFFF5EBDD),
    Color(0xFFB8A593),
    Color(0xFFE07A4F),
    Color(0xFF3A2E26),
  );

  /// Returns the palette matching the current theme brightness.
  static Palette of(BuildContext c) =>
      Theme.of(c).brightness == Brightness.dark ? dark : light;
}

/// Builds a complete [ThemeData] for the given brightness.
///
/// We start from Material 3 defaults and layer our custom palette
/// colours on top (scaffold background, app bar, navigation bar, text).
ThemeData buildTheme(Brightness b) {
  final p = b == Brightness.dark ? Palette.dark : Palette.light;
  final base = ThemeData(
    brightness: b,
    useMaterial3: true,
    scaffoldBackgroundColor: p.bg,
    colorScheme: ColorScheme.fromSeed(seedColor: p.accent, brightness: b),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(bodyColor: p.text, displayColor: p.text),
    appBarTheme: AppBarTheme(
      backgroundColor: p.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: p.text,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: p.card,
      indicatorColor: p.accent.withAlpha(40),
    ),
  );
}

/// Convenience for the heading text style used across screens.
///
/// Uses Google Fonts' Baloo 2, a friendly rounded typeface that
/// complements the hand-drawn Warli aesthetic.
TextStyle heading(BuildContext c, {double size = 24}) => GoogleFonts.baloo2(
    fontSize: size, fontWeight: FontWeight.w700, color: Palette.of(c).text);
