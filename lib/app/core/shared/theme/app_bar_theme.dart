import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/theme/text_theme.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    surfaceTintColor: lightColorScheme.background,
    titleTextStyle: TTextTheme.lightTextTheme.headlineMedium?.copyWith(
      fontFamily: GoogleFonts.poppins().fontFamily,
    ),
    iconTheme: IconThemeData(
      color: lightColorScheme.primary,
      size: 35.w,
    ),
    actionsIconTheme: IconThemeData(
      color: lightColorScheme.primary,
      size: 35.w,
    ),
  );

  // Tema AppBar Gelap - BARU
  static AppBarTheme darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    toolbarHeight: 100.h,
    scrolledUnderElevation: 0,
    backgroundColor:
        darkColorScheme.background, // Latar belakang AppBar untuk mode gelap
    surfaceTintColor: Colors.transparent, // Atau darkColorScheme.background
    titleTextStyle: TTextTheme.darkTextTheme.headlineMedium?.copyWith(
      fontFamily: GoogleFonts.quicksand().fontFamily,
      color: darkColorScheme
          .primary, // Judul AppBar menggunakan warna primer gelap
    ),
    iconTheme: IconThemeData(
      color:
          darkColorScheme.primary, // Ikon utama menggunakan warna primer gelap
      size: 35.w,
    ),
    actionsIconTheme: IconThemeData(
      color: darkColorScheme
          .primary, // Ikon di actions menggunakan warna primer gelap
      size: 35.w,
    ),
  );
}
