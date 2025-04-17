import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/theme/text_theme.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: lightColorScheme.background,
    titleTextStyle: TTextTheme.lightTextTheme.headlineMedium,
    iconTheme: IconThemeData(
      size: 48,
      color: lightColorScheme.primary,
    ),
    elevation: 0,
  );
}
