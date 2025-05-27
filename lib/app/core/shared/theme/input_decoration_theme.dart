import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/theme/text_theme.dart';


// Warna gradient yang Anda inginkan
const List<Color> kDefaultGradientBorderColors = [
  Color(0xFFA2FF00),
  Color(0xFF00FF7F),
];

// Warna gradient untuk fokus (bisa sama atau berbeda)
const List<Color> kFocusedGradientBorderColors = [
  Color(0xFFA2FF00), // Atau warna lain yang lebih intens
  Color(0xFF00FF7F),
];


class TInputDecorationTheme {
  const TInputDecorationTheme._();

  static final lightInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: lightColorScheme.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: lightColorScheme.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    hintStyle: TTextTheme.lightTextTheme.titleSmall!.copyWith(
      color: lightColorScheme.onTertiary,
    ),
  );

  static final InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    // Menghilangkan border default atau membuatnya tidak terlihat
    border: InputBorder.none, // Atau OutlineInputBorder(borderSide: BorderSide.none)
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none, // Border fokus akan di-handle oleh wrapper
    errorBorder: OutlineInputBorder( // Error border bisa tetap solid sebagai fallback
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: darkColorScheme.error), // Menggunakan warna error dari scheme
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: darkColorScheme.error, width: 2),
    ),
    // Properti lain yang sudah Anda definisikan
    filled: true,
    fillColor: const Color(0xFF2E2E2E), // Warna isian yang Anda inginkan
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    hintStyle: TTextTheme.darkTextTheme.bodyMedium,
    labelStyle: TTextTheme.darkTextTheme.bodyMedium?.copyWith(
      color: darkColorScheme.onSurfaceVariant,
    ),
    floatingLabelStyle: TTextTheme.darkTextTheme.bodyMedium?.copyWith(
      color: darkColorScheme.primary, // Warna label ketika fokus
    ),
    // Pastikan helperStyle, errorStyle, dll juga didefinisikan jika perlu
    errorStyle: TTextTheme.darkTextTheme.bodyMedium?.copyWith( // Contoh untuk error style
      color: darkColorScheme.error,
    ),
  );
}
