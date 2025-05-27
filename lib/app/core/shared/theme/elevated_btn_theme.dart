import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/theme/text_theme.dart';

// --- Konstanta untuk Gradient ---
const LinearGradient kAppDefaultButtonGradient = LinearGradient(
  colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

// Gradient untuk kondisi disabled (contoh: abu-abu)
const LinearGradient kAppDisabledButtonGradient = LinearGradient(
  colors: [Color(0xFFBDBDBD), Color(0xFFBDBDBD)], // Abu-abu solid
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
// --- Akhir Konstanta untuk Gradient ---

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

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ButtonStyle(
      // Gaya teks untuk tombol
      textStyle: MaterialStateProperty.all(
        TTextTheme.darkTextTheme.labelMedium,
      ),
      // Elevation diatur ke 0 karena kita menggunakan gradient kustom
      elevation: MaterialStateProperty.all(0),
      // Ukuran minimum tombol, terutama tingginya
      minimumSize: MaterialStateProperty.all(const Size.fromHeight(43)),
      // Bentuk tombol (misalnya, rounded rectangle atau pill shape)
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9), // Bentuk kapsul/pil
        ),
      ),
      // Latar belakang tombol dibuat transparan agar gradient bisa terlihat
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      // Warna teks dan ikon pada tombol
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            // Warna teks/ikon saat tombol disabled (di atas gradient abu-abu)
            return Colors.white.withOpacity(0.8);
          }
          // Warna teks/ikon saat tombol enabled (di atas gradient hijau)
          return Colors.black;
        },
      ),
      // Padding internal tombol diatur ke zero karena akan di-handle oleh Container di widget kustom
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      // Penting untuk Material 3: mencegah tinting pada background transparan
      surfaceTintColor: MaterialStateProperty.all(Colors.transparent),
      // Splash color bisa disesuaikan jika perlu
      // overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
      //   if (states.contains(MaterialState.pressed)) {
      //     return Colors.black.withOpacity(0.1); // Warna saat ditekan
      //   }
      //   return null;
      // }),
    ),
  );
}
