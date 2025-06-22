import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';

// ✨ Dibuat sebagai StatefulWidget untuk mengelola state internal (jumlah stamina)
class UseStaminaDialog extends StatefulWidget {
  const UseStaminaDialog({
    super.key,
    required this.title,
    required this.subtitle,
    // ✨ 1. Menerima fungsi yang membangun widget tombol konfirmasi secara dinamis
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
  final String subtitle;
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
            vertical: 12,
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
                widget.subtitle,
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
                      height: 45,
                      child: GradientOutlinedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        child: Text(
                          widget.labelCancel ?? 'Back',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
                        ),
                        onPressed: widget.onCancel ?? () => Get.back(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 45,
                      child: GradientElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
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
        _buildStaminaButton(icon: Icons.remove, onPressed: _decrement),
        const SizedBox(width: 24),
        // Tampilan Nilai Stamina
        Row(
          children: [
            const Icon(Icons.flash_on, color: Color(0xFFA2FF00), size: 24),
            const SizedBox(width: 8),
            Text(
              '$_currentValue',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(width: 24),
        // Tombol Increment
        _buildStaminaButton(icon: Icons.add, onPressed: _increment),
      ],
    );
  }

  // Helper untuk membuat tombol increment/decrement
  Widget _buildStaminaButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.black),
        onPressed: onPressed,
      ),
    );
  }
}
