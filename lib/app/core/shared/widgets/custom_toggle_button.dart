import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ✨ Widget utama yang akan Anda panggil ✨
// Dibuat stateless karena state-nya akan dikelola oleh parent (misal: GetxController)
class CustomToggleButton extends StatelessWidget {
  // Nilai saat ini (true = on, false = off)
  final bool value;
  // Callback yang akan dipanggil saat tombol ditekan
  final ValueChanged<bool> onChanged;
  // Warna saat tombol aktif (on)
  final Color activeColor;
  // Warna saat tombol tidak aktif (off)
  final Color inactiveColor;

  final Gradient? activeGradient;

  const CustomToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color(0xFFA2FF00), // Warna hijau Zest+
    this.inactiveColor = const Color(0xFF767676),
    this.activeGradient,
  });

  @override
  Widget build(BuildContext context) {
    // Durasi untuk semua animasi
    const duration = Duration(milliseconds: 300);

    return GestureDetector(
      // Panggil callback saat area ditekan
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: duration,
        width: 50.w,  // Lebar total tombol
        height: 27.h, // Tinggi total tombol
        decoration: BoxDecoration(
          // Ganti warna background berdasarkan state 'value'
          gradient: value ? activeGradient : null,
          color: value && activeGradient == null ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        // Gunakan AnimatedAlign untuk menganimasikan posisi lingkaran (thumb)
        child: AnimatedAlign(
          duration: duration,
          // Atur kurva animasi agar terasa lebih natural
          curve: Curves.easeInOutCubic,
          // Posisikan lingkaran ke kanan jika 'on', ke kiri jika 'off'
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(4.h),
            child: Container(
              width: 21.w, // Lebar lingkaran
              height: 21.h, // Tinggi lingkaran
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  // Bayangan untuk memberikan efek 3D pada lingkaran
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    spreadRadius: 1,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}