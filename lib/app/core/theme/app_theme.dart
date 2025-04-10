import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/theme/app_bar_theme.dart';
import 'package:zest_mobile/app/core/theme/checkbox_theme.dart';
import 'package:zest_mobile/app/core/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/theme/elevated_btn_theme.dart';
import 'package:zest_mobile/app/core/theme/input_decoration_theme.dart';
import 'package:zest_mobile/app/core/theme/text_theme.dart';

class TAppTheme {
  const TAppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightColorScheme.background,
      primaryColor: lightColorScheme.primary,
      appBarTheme: TAppBarTheme.lightAppBarTheme,
      textTheme: TTextTheme.lightTextTheme,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
      inputDecorationTheme: TInputDecorationTheme.lightInputDecorationTheme,
      checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
      fontFamily: GoogleFonts.quicksand().fontFamily,
    );
  }
}
