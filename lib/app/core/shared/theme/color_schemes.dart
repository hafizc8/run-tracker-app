import 'package:flutter/material.dart';

ColorScheme get lightColorScheme => const ColorScheme(
      brightness: Brightness.light, // brightness wajib

      primary: Color(0xFF007AFF), // biru utama (misal untuk tombol)
      onPrimary: Colors.white, // teks/icon di atas warna primary

      secondary: Color(0xFF999999), // abu sekunder (misal untuk chip/checkbox)
      onSecondary: Colors.white, // teks/icon di atas secondary

      background: Colors.white, // latar belakang utama (scaffold, body)
      onBackground: Color(0xFF090909), // teks di atas background

      surface: Colors.white, // latar elemen seperti Card/TextField
      onSurface: Color(0xFF1C1C1E), // teks/icon di atas surface

      error: Colors.red, // warna merah error
      onError: Colors.white, // teks/icon di atas warna error

      surfaceVariant:
          Color(0xFFF2F2F7), // variasi permukaan, biasanya abu lembut
      onSurfaceVariant:
          Color(0xFF6E6E73), // hint text, label kecil, teks placeholder

      outline: Color(0XFFD9D9D9), // warna border (TextField, Checkbox, dll)

      onTertiary: Color(0xFFB3B3B3),
      tertiary: Color(0xFFB3B3B3),
    );
