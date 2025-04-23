import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/theme/text_theme.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: lightColorScheme.background,
    titleTextStyle: TTextTheme.lightTextTheme.headlineMedium?.copyWith(
      fontFamily: GoogleFonts.quicksand().fontFamily,
    ),
  );
}
