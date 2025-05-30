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

// Skema Warna Gelap (Dark Mode) - Ditambahkan
ColorScheme get darkColorScheme => const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFA2FF00), // Biru Apple yang sedikit lebih cerah untuk dark mode
  onPrimary: Color(0xFF292929), // Teks putih di atas warna primer
  secondary: Color(0xFF636363), // Abu-abu sedang untuk dark mode
  onSecondary: Colors.white,
  background: Color(0xFF292929), // Hitam pekat untuk latar belakang utama
  onBackground: Color(0xFFDCDCDC), // Putih gading untuk teks utama di latar belakang gelap
  surface: Color(0xFF2E2E2E), // Abu-abu gelap untuk card, sheet (iOS dark mode style)
  onSurface: Color(0xFFE5E5EA), // Putih gading untuk teks di atas surface
  error: Color(0xFFFF453A), // Merah yang lebih cerah untuk dark mode
  onError: Colors.black, // Teks hitam di atas warna error (kontras lebih baik)
  surfaceVariant: Color(0xFF2C2C2E), // Abu-abu lebih gelap untuk varian surface
  onSurfaceVariant: Color(0xFF98989D), // Abu-abu muda untuk teks sekunder/placeholder
  outline: Color(0xFF48484A), // Abu-abu gelap untuk border
  onTertiary: Color(0xFF48484A), // Warna untuk elemen tersier jika diperlukan (gelap)
  tertiary: Color(0xFF3D3D3D), // Warna dasar elemen tersier jika diperlukan (gelap)
);