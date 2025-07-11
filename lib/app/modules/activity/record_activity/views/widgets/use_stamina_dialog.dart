import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';

// ✨ Dibuat sebagai StatefulWidget untuk mengelola state internal (jumlah stamina)
class UseStaminaDialog extends StatefulWidget {
  const UseStaminaDialog({
    super.key,
    required this.title,
    required this.subtitleBuilder,
    required this.labelConfirmBuilder,
    // ✨ 2. onConfirm sekarang menerima nilai integer terakhir
    required this.onConfirm,
    this.labelCancel,
    this.onCancel,
    // ✨ 3. Parameter untuk mengontrol counter stamina
    this.initialValue = 1,
    this.minValue = 1,
    this.maxValue = 10,
    // ✨ 4. Opsi untuk menambahkan widget kustom, dalam kasus ini tidak kita gunakan
    // karena stamina selector adalah bagian dari dialog ini.
    this.customContent, 
  });

  final String title;
  final String Function(int currentValue) subtitleBuilder;
  final Widget Function(int currentValue) labelConfirmBuilder;
  final Function(int finalValue) onConfirm;
  final String? labelCancel;
  final Function()? onCancel;
  final int initialValue;
  final int minValue;
  final int maxValue;
  final Widget? customContent;

  @override
  State<UseStaminaDialog> createState() =>
      _UseStaminaDialogState();
}

class _UseStaminaDialogState
    extends State<UseStaminaDialog> {
  // State untuk menyimpan nilai stamina saat ini
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  void _increment() {
    if (_currentValue < widget.maxValue) {
      setState(() {
        _currentValue++;
      });
    }
  }

  void _decrement() {
    if (_currentValue > widget.minValue) {
      setState(() {
        _currentValue--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Styling yang sama dengan dialog sebelumnya
    return Dialog(
      surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      insetPadding: const EdgeInsets.all(32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Align(
                alignment: Alignment.topCenter,
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                  ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.subtitleBuilder(_currentValue),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 16),

              // ✨ KUNCI: Widget baru untuk memilih stamina
              _buildStaminaSelector(),

              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38.h,
                      child: GradientOutlinedButton(
                        contentPadding: const EdgeInsets.all(0),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        onPressed: widget.onCancel ?? () => Get.back(),
                        child: Text(
                          widget.labelCancel ?? 'Back',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 38.h,
                      child: GradientElevatedButton(
                        contentPadding: const EdgeInsets.all(0),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        // ✨ Panggil onConfirm dengan nilai terakhir
                        onPressed: () => widget.onConfirm(_currentValue),
                        // ✨ Bangun child tombol secara dinamis
                        child: widget.labelConfirmBuilder(_currentValue),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk bagian pemilih stamina
  Widget _buildStaminaSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tombol Decrement
        _buildStaminaButton(
          icon: SvgPicture.asset(
            'assets/icons/ic_min.svg',
            width: 15.w,
          ), 
          onPressed: _decrement,
        ),
        SizedBox(width: 18.w),
        // Tampilan Nilai Stamina
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: const Color(0xFFA2FF00), 
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/ic_energy_2.svg',
                width: 12.w,
                height: 18.w,
              ),
              SizedBox(width: 16.w),
              Text(
                '$_currentValue',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 18.w),
        // Tombol Increment
        _buildStaminaButton(
          icon: SvgPicture.asset(
            'assets/icons/ic_add.svg',
            width: 15.w,
          ),
          onPressed: _increment,
        ),
      ],
    );
  }

  // Helper untuk membuat tombol increment/decrement
  Widget _buildStaminaButton({required Widget icon, required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 32.w,
        height: 32.w,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: icon,
      ),
    );
  }
}
