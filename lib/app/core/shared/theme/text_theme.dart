import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';

class TTextTheme {
  TTextTheme._();

  static final TextTheme lightTextTheme = TextTheme(
    headlineMedium: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: lightColorScheme.primary,
    ),
    headlineSmall: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: lightColorScheme.primary,
    ),
    titleSmall: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: lightColorScheme.onBackground,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: lightColorScheme.onBackground,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.sp,
      color: lightColorScheme.onBackground,
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
      color: lightColorScheme.onBackground,
    ),
    labelLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: lightColorScheme.onPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: lightColorScheme.onPrimary,
    ),
    labelSmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: lightColorScheme.onPrimary,
    ),
  );

  // Tema Teks Gelap (Dark Mode) - Ditambahkan
  static final TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color:
          darkColorScheme.primary, // Menggunakan primary dari darkColorScheme
    ),
    headlineMedium: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color:
          darkColorScheme.primary, // Menggunakan primary dari darkColorScheme
    ),
    headlineSmall: TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
      color: darkColorScheme.primary,
    ),
    titleLarge: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w400,
      color: darkColorScheme.onBackground, // Teks utama di latar belakang gelap
    ),
    titleMedium: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w400,
      color: darkColorScheme.onBackground, // Teks utama di latar belakang gelap
    ),
    titleSmall: TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
      color: darkColorScheme.onBackground, // Teks utama di latar belakang gelap
    ),
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: darkColorScheme.onBackground, // Teks utama di latar belakang gelap
    ),
    bodyMedium: TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: darkColorScheme.onBackground,
    ),
    bodySmall: TextStyle(
      fontSize: 12.sp,
      color: darkColorScheme.onBackground, // Teks utama di latar belakang gelap
    ),
    labelLarge: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w900,
      color: darkColorScheme
          .onPrimary, // Teks di atas tombol dengan background primary gelap
    ),
    labelMedium: TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
      color: darkColorScheme.onPrimary, // Teks di atas tombol
    ),
    labelSmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: darkColorScheme.onPrimary, // Teks di atas tombol
    ),
  );
}
