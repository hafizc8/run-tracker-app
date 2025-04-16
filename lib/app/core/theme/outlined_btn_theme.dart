import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/theme/text_theme.dart';

class TOutlinedButtonTheme {
  const TOutlinedButtonTheme._();
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(
        TTextTheme.lightTextTheme.labelSmall,
      ),
      elevation: MaterialStateProperty.all(0),
      minimumSize: MaterialStateProperty.all(const Size.fromHeight(56)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return lightColorScheme.onSurface.withOpacity(0.12);
          }
          if (states.contains(MaterialState.pressed)) {
            return lightColorScheme.background;
          }
          return lightColorScheme.background;
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return lightColorScheme.onSurface.withOpacity(0.38);
          }
          return lightColorScheme.primary;
        },
      ),
    ),
  );
}
