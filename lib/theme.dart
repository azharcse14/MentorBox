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
  static const Color kSurface = Color(0xFFF4F3EC);
  static const Color kSuccess = Color(0xFF5FA97A);
  static const Color kDanger = Color(0xFFD9645F);

  static const String bebas = 'BebasNeue';
  static const String shareTech = 'ShareTech';
  static const String poppins = 'Poppins';

  /// Big condensed headings (Bebas Neue).
  static TextStyle display(double size, {Color color = kGreyShade800}) =>
      TextStyle(fontFamily: bebas, fontSize: size, color: color, height: 1.05);

  /// Short UI text such as greetings and small facts (Share Tech).
  static TextStyle mono(
    double size, {
    Color color = kGreyShade800,
    FontWeight weight = FontWeight.w400,
  }) =>
      TextStyle(fontFamily: shareTech, fontSize: size, color: color, fontWeight: weight);

  /// Reading text for lessons (Poppins).
  static TextStyle body(
    double size, {
    Color color = kGreyShade800,
    FontWeight weight = FontWeight.w400,
    double height = 1.55,
    FontStyle style = FontStyle.normal,
  }) =>
      TextStyle(
        fontFamily: poppins,
        fontSize: size,
        color: color,
        fontWeight: weight,
        height: height,
        fontStyle: style,
      );

  static ThemeData lightTheme = ThemeData(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kScaffoldBackgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimaryColor,
      primary: kPrimaryColor,
    ),
    fontFamily: poppins,
    appBarTheme: const AppBarTheme(
      backgroundColor: kScaffoldBackgroundColor,
      foregroundColor: kGreyShade800,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: bebas, fontSize: 36, color: kGreyShade800),
      displayMedium: TextStyle(fontFamily: bebas, fontSize: 24, color: kSubheadingColor),
      displaySmall: TextStyle(fontFamily: bebas, fontSize: 20, color: kPrimaryColor),
      bodyLarge: TextStyle(fontFamily: poppins, fontSize: 16, color: Colors.black),
      bodyMedium: TextStyle(fontFamily: poppins, fontSize: 14, color: kGreyShade800),
    ),
  );
}
