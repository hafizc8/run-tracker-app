import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/theme/text_theme.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    surfaceTintColor: lightColorScheme.background,
    titleTextStyle: TTextTheme.lightTextTheme.headlineMedium?.copyWith(
      fontFamily: GoogleFonts.quicksand().fontFamily,
    ),
    iconTheme: IconThemeData(
      color: lightColorScheme.primary,
      size: 32,
    ),
    actionsIconTheme: IconThemeData(
      color: lightColorScheme.primary,
      size: 32,
    ),
  );
}
