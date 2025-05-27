import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';

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
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: lightColorScheme.onPrimary,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: lightColorScheme.onPrimary,
    ),
  );

  // Tema Teks Gelap (Dark Mode) - Ditambahkan
  static final TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: darkColorScheme.primary, // Menggunakan primary dari darkColorScheme
    ),
    headlineMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: darkColorScheme.primary, // Menggunakan primary dari darkColorScheme
    ),
    headlineSmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: darkColorScheme.primary,
    ),

    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: darkColorScheme.onBackground, // Teks utama di latar belakang gelap
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: darkColorScheme.onBackground, // Teks utama di latar belakang gelap
    ),
    titleSmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: darkColorScheme.onBackground, // Teks utama di latar belakang gelap
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: darkColorScheme.onBackground, // Teks utama di latar belakang gelap
    ),
    bodyMedium: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: darkColorScheme.secondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: darkColorScheme.onBackground, // Teks utama di latar belakang gelap
    ),

    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: darkColorScheme.onPrimary, // Teks di atas tombol dengan background primary gelap
    ),
    labelMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: darkColorScheme.onPrimary, // Teks di atas tombol
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: darkColorScheme.onPrimary, // Teks di atas tombol
    ),
  );
}
