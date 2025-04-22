import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/theme/app_bar_theme.dart';
import 'package:zest_mobile/app/core/shared/theme/checkbox_theme.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/theme/elevated_btn_theme.dart';
import 'package:zest_mobile/app/core/shared/theme/input_decoration_theme.dart';
import 'package:zest_mobile/app/core/shared/theme/outlined_btn_theme.dart';
import 'package:zest_mobile/app/core/shared/theme/text_theme.dart';

class TAppTheme {
  const TAppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: lightColorScheme.background,
      primaryColor: lightColorScheme.primary,
      appBarTheme: TAppBarTheme.lightAppBarTheme,
      textTheme: TTextTheme.lightTextTheme,
      elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
      inputDecorationTheme: TInputDecorationTheme.lightInputDecorationTheme,
      checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
      fontFamily: GoogleFonts.quicksand().fontFamily,
    );
  }
}
