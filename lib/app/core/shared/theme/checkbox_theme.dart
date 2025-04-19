import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';

class TCheckboxTheme {
  TCheckboxTheme._();

  static final lightCheckboxTheme = CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey; // Warna ketika disabled
      }
      if (states.contains(MaterialState.selected)) {
        return Colors.black; // Warna ketika dicentang
      }

      return Colors.grey.shade400; // Warna default border
    }),

    checkColor: MaterialStateProperty.all(Colors.white), // warna centang

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),

    side: BorderSide(
      color: lightColorScheme.outline, // border saat belum dicentang
      width: 1.5,
    ),
  );
}
