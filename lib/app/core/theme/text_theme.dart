import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/theme/color_schemes.dart';

class TTextTheme {
  TTextTheme._();

  static final TextTheme lightTextTheme = TextTheme(
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: lightColorScheme.primary,
    ),
    headlineSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: lightColorScheme.primary,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: lightColorScheme.onBackground,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: lightColorScheme.onBackground,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: lightColorScheme.onBackground,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: lightColorScheme.onBackground,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: lightColorScheme.onPrimary,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: lightColorScheme.onPrimary,
    ),
  );
}
