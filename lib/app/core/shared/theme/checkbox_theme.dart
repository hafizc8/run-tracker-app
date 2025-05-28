import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart'; // Pastikan path ini benar

class TCheckboxTheme {
  TCheckboxTheme._();

  static final lightCheckboxTheme = CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey; // Warna ketika disabled (tetap)
      }
      if (states.contains(MaterialState.selected)) {
        return Colors.white; // ✅ Diubah: Warna isi putih ketika dicentang
      }
      // Warna default ketika tidak dicentang (misalnya, warna latar belakang 'kosong' atau border saja)
      // Jika Anda ingin hanya border yang terlihat saat tidak dicentang, Anda bisa return Colors.transparent
      // atau biarkan seperti ini jika Colors.grey.shade400 adalah warna 'kosong' yang diinginkan.
      return Colors.grey.shade400; 
    }),
    checkColor: MaterialStateProperty.resolveWith((states) { // ✅ Diubah: Logika untuk warna centang
      if (states.contains(MaterialState.selected)) {
        return Colors.black; // ✅ Diubah: Warna centang hitam ketika checkbox dicentang
      }
      return Colors.white; // Warna default untuk centang (meskipun tidak terlihat jika tidak selected)
    }),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4), // Bentuk (tetap)
    ),
    side: MaterialStateBorderSide.resolveWith((states) { // Menggunakan resolveWith untuk side juga
      if (states.contains(MaterialState.disabled)) {
        return BorderSide(
          color: Colors.grey.shade300, // Warna border ketika disabled
          width: 1.5,
        );
      }
      if (states.contains(MaterialState.selected)) {
        // Saat terpilih dan fillColor putih, Anda mungkin ingin border yang kontras
        // atau tidak sama sekali jika fill putih sudah cukup.
        // Jika ingin border tetap ada saat selected:
        return const BorderSide(
          color: Colors.black, // Contoh: border hitam saat terpilih dengan fill putih
          width: 1.5,
        );
      }
      // Border saat belum dicentang (default)
      return BorderSide(
        color: lightColorScheme.outline, 
        width: 1.5,
      );
    }),
  );
}