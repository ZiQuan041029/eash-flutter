import 'package:flutter/material.dart';

/// Brand colors and gradients aligned with EA Social House / EASH PDF designs.
abstract final class EashColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cardGrey = Color(0xFF1C1C1E);
  static const Color mutedText = Color(0xFF8E8E93);
  static const Color disabledButton = Color(0xFF3A3A3C);
  static const Color welcomePink = Color(0xFFFF2D92);
  static const Color gradientBlue = Color(0xFF2948FF);

  /// Login header gradient (Welcome Back card).
  static const Color loginMagentaDark = Color(0xFFFF4BFA);
  static const Color loginMagentaLight = Color(0xFFFFB6FE);

  /// Primary brand magenta used across gradients.
  static const Color brandMagenta = loginMagentaDark;
  static const Color landingPink = Color(0xFFFF3CAC);
  static const Color landingPurple = Color(0xFF2B1054);
  static const Color limeHello = Color(0xFFB8FF2A);
  static const Color blueNamaste = Color(0xFF3A6FF8);
  static const Color yellowVanakkam = Color(0xFFFFE135);
}

abstract final class EashGradients {
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[EashColors.gradientBlue, EashColors.brandMagenta],
  );

  static const LinearGradient landing = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[EashColors.landingPink, EashColors.landingPurple],
  );
}

ThemeData buildEashTheme() {
  final TextTheme base = ThemeData(brightness: Brightness.dark).textTheme;
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: EashColors.black,
    colorScheme: const ColorScheme.dark(
      primary: EashColors.gradientBlue,
      secondary: EashColors.brandMagenta,
      surface: EashColors.cardGrey,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: EashColors.white,
      centerTitle: false,
    ),
    textTheme: base.apply(
      bodyColor: EashColors.white,
      displayColor: EashColors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: EashColors.white,
      hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
