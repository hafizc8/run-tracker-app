import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/theme/text_theme.dart';

class TElevatedButtonTheme {
  const TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        TTextTheme.lightTextTheme.labelSmall,
      ),
      elevation: MaterialStateProperty.all(0),
      minimumSize: MaterialStateProperty.all(const Size.fromHeight(56)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return lightColorScheme.onSurface.withOpacity(0.12);
          }
          if (states.contains(MaterialState.pressed)) {
            return lightColorScheme.primary.withOpacity(0.8);
          }
          return lightColorScheme.primary;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return lightColorScheme.onSurface.withOpacity(0.38);
          }
          return lightColorScheme.onPrimary;
        },
      ),
    ),
  );
}
