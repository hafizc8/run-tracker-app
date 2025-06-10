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
      fontFamily: GoogleFonts.poppins().fontFamily,
    );
  }

  // Tema Gelap - BARU (dan akan menjadi tema utama)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true, // Direkomendasikan untuk Flutter modern
      brightness: Brightness.dark,
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: darkColorScheme.background,
      primaryColor: darkColorScheme
          .primary, // primaryColor usang, gunakan colorScheme.primary
      appBarTheme: TAppBarTheme.darkAppBarTheme,
      textTheme: TTextTheme.darkTextTheme
          .apply(fontFamily: GoogleFonts.poppins().fontFamily),
      elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
      // outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
      inputDecorationTheme: TInputDecorationTheme.darkInputDecorationTheme,
      // checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
      fontFamily: GoogleFonts.poppins().fontFamily,
    );
  }
}
