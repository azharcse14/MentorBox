import 'package:flutter/material.dart';

/// Colors and text styles for the whole app.
/// Fonts are bundled in assets/fonts, so nothing is downloaded at runtime.
class AppTheme {
  static const Color kPrimaryColor = Color(0xFFED8664);
  static const Color kScaffoldBackgroundColor = Color(0xFFDEDDD2);
  static const Color kAppBarBackgroundColor = Color(0xFFED8664);
  static const Color kSubheadingColor = Color(0xFF999999);
  static const Color kWhite70 = Colors.white70;
  static const Color kGreyShade800 = Color(0xFF424242);
  static const Color kSuccess = Color(0xFF5FA97A);
  static const Color kDanger = Color(0xFFD9645F);

  static const Color _darkBackground = Color(0xFF1E1D1A);
  static const Color _darkSurface = Color(0xFF2B2A26);
  static const Color _darkCard = Color(0xFF35332F);
  static const Color _darkText = Color(0xFFE6E4DA);

  /// True while the dark theme is showing. Set in MaterialApp.builder.
  // ponytail: one global flag plus a full rebuild on change (see main.dart);
  // move these to a ThemeExtension read through context if it gets in the way.
  static bool isDark = false;

  // Colors below follow light/dark mode. The k* constants above stay the same
  // in both, so they are still right on the always-dark cards.
  static Color get kBackground => isDark ? _darkBackground : kScaffoldBackgroundColor;
  static Color get kSurface => isDark ? _darkSurface : const Color(0xFFF4F3EC);
  static Color get kCard => isDark ? _darkCard : Colors.white;
  static Color get kText => isDark ? _darkText : kGreyShade800;

  static const String bebas = 'BebasNeue';
  static const String shareTech = 'ShareTech';
  static const String poppins = 'Poppins';

  /// The fonts above have no Bangla letters, so Bangla text uses this one.
  static const List<String> fallback = ['HindSiliguri'];

  /// Big condensed headings (Bebas Neue).
  static TextStyle display(double size, {Color? color}) =>
      TextStyle(fontFamily: bebas, fontFamilyFallback: fallback, fontSize: size, color: color ?? kText, height: 1.05);

  /// Short UI text such as greetings and small facts (Share Tech).
  static TextStyle mono(
    double size, {
    Color? color,
    FontWeight weight = FontWeight.w400,
  }) =>
      TextStyle(
        fontFamily: shareTech,
        fontFamilyFallback: fallback,
        fontSize: size,
        color: color ?? kText,
        fontWeight: weight,
      );

  /// Reading text for lessons (Poppins).
  static TextStyle body(
    double size, {
    Color? color,
    FontWeight weight = FontWeight.w400,
    double height = 1.55,
    FontStyle style = FontStyle.normal,
  }) =>
      TextStyle(
        fontFamily: poppins,
        fontFamilyFallback: fallback,
        fontSize: size,
        color: color ?? kText,
        fontWeight: weight,
        height: height,
        fontStyle: style,
      );

  static final ThemeData lightTheme = _theme(Brightness.light);
  static final ThemeData darkTheme = _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final background = dark ? _darkBackground : kScaffoldBackgroundColor;
    final text = dark ? _darkText : kGreyShade800;
    return ThemeData(
      brightness: brightness,
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimaryColor,
        primary: kPrimaryColor,
        brightness: brightness,
      ),
      fontFamily: poppins,
      fontFamilyFallback: fallback,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontFamily: bebas, fontSize: 36, color: text),
        displayMedium: const TextStyle(fontFamily: bebas, fontSize: 24, color: kSubheadingColor),
        displaySmall: const TextStyle(fontFamily: bebas, fontSize: 20, color: kPrimaryColor),
        bodyLarge: TextStyle(fontFamily: poppins, fontSize: 16, color: dark ? _darkText : Colors.black),
        bodyMedium: TextStyle(fontFamily: poppins, fontSize: 14, color: text),
      ),
    );
  }
}
