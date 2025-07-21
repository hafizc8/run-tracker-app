import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';

// =========================================================================
// KELAS-KELAS KUSTOM UNTUK SLIDER
// =========================================================================

/// 1. Custom Shape untuk Thumb (Lingkaran Utama) dengan Gradien
class _GradientThumbShape extends SliderComponentShape {
  final double thumbRadius;
  const _GradientThumbShape({this.thumbRadius = 16.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.fromRadius(thumbRadius);

  @override
  void paint(PaintingContext context, ui.Offset center, {required Animation<double> activationAnimation, required Animation<double> enableAnimation, required bool isDiscrete, required TextPainter labelPainter, required RenderBox parentBox, required SliderThemeData sliderTheme, required ui.TextDirection textDirection, required double value, required double textScaleFactor, required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;
    final rect = Rect.fromCircle(center: center, radius: thumbRadius);
    const gradient = LinearGradient(colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)]);
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawCircle(center, thumbRadius, paint);
  }
}

/// 2. Custom Shape untuk Track (Garis Slider) dengan Gradien
class _GradientRectSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    ui.Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required ui.TextDirection textDirection,
    required ui.Offset thumbCenter,
    ui.Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2.0,
  }) {
    // Tentukan warna dan gradien
    const Color inactiveTrackColor = Color(0xFFD9D9D9);
    const Gradient activeTrackGradient = LinearGradient(colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)]);

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    
    // Gambar bagian aktif (gradien)
    final Rect activeTrackSegment = Rect.fromLTRB(trackRect.left, trackRect.top, thumbCenter.dx, trackRect.bottom);
    final Paint activePaint = Paint()..shader = activeTrackGradient.createShader(activeTrackSegment);
    context.canvas.drawRRect(RRect.fromRectAndCorners(activeTrackSegment, topLeft: Radius.circular(trackRect.height / 2), bottomLeft: Radius.circular(trackRect.height / 2)), activePaint);
    
    // Gambar bagian tidak aktif (abu-abu)
    final Rect inactiveTrackSegment = Rect.fromLTRB(thumbCenter.dx, trackRect.top, trackRect.right, trackRect.bottom);
    final Paint inactivePaint = Paint()..color = inactiveTrackColor;
    context.canvas.drawRRect(RRect.fromRectAndCorners(inactiveTrackSegment, topRight: Radius.circular(trackRect.height / 2), bottomRight: Radius.circular(trackRect.height / 2)), inactivePaint);
  }
}

/// 3. Custom Shape untuk Tick (Titik) dengan Gradien
class _CustomSliderTickMarkShape extends SliderTickMarkShape {
  final double tickRadius;
  const _CustomSliderTickMarkShape({this.tickRadius = 9.5}); // Diameter 19px

  @override
  ui.Size getPreferredSize({required SliderThemeData sliderTheme, required bool isEnabled}) => ui.Size.fromRadius(tickRadius);

  @override
  void paint(
    PaintingContext context,
    ui.Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required ui.Offset thumbCenter,
    required bool isEnabled,
    required ui.TextDirection textDirection,
  }) {
    final ui.Canvas canvas = context.canvas;
    final paint = ui.Paint();
    
    // Cek apakah tick ini berada di bagian aktif atau tidak
    if (center.dx <= thumbCenter.dx) {
      // Tick Aktif (Gradien)
      final rect = ui.Rect.fromCircle(center: center, radius: tickRadius);
      const gradient = LinearGradient(colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)]);
      paint.shader = gradient.createShader(rect);
    } else {
      // Tick Tidak Aktif (Abu-abu)
      paint.color = const Color(0xFFD9D9D9);
    }
    
    canvas.drawCircle(center, tickRadius, paint);
  }
}


class SetDailyGoalDialog extends StatefulWidget {
  const SetDailyGoalDialog({super.key, required this.onSave});
  final Function(int selectedGoal) onSave;

  @override
  State<SetDailyGoalDialog> createState() => _SetDailyGoalDialogState();
}

class _SetDailyGoalDialogState extends State<SetDailyGoalDialog> {
  final List<int> _goalSteps = [5000, 7500, 10000, 12500, 15000];
  double _currentSliderIndex = 0.0;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final selectedSteps = _goalSteps[_currentSliderIndex.round()];
    
    return Dialog(
      surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
      insetPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 32.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.onPrimary, borderRadius: BorderRadius.circular(14)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildSteppedSlider(),
                const SizedBox(height: 12),
                Text(
                  '${NumberFormat('#,###', 'id_ID').format(selectedSteps)} Steps', 
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: GradientElevatedButton(
                    contentPadding: const EdgeInsets.all(0),
                    onPressed: _isSaving ? null : () async {
                      setState(() => _isSaving = true);
                      await widget.onSave(selectedSteps);
                    },
                    child: 
                      _isSaving 
                      ? CustomCircularProgressIndicator(indicatorSize: 18.r)
                      : Text(
                        'Save', 
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp, 
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF292929),
                        ),
                      ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
            child: Text(
              'Welcome to ZEST+', 
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Set your daily goals to begin', 
          textAlign: TextAlign.center, 
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSteppedSlider() {
    return SliderTheme(
      // ✨ KUNCI PERBAIKAN: Menggunakan kembali implementasi custom shape yang robust
      data: SliderTheme.of(context).copyWith(
        trackShape: _GradientRectSliderTrackShape(),
        trackHeight: 8.5, // Menggunakan nilai tetap, bukan yang diskalakan (.h)
        thumbShape: _GradientThumbShape(thumbRadius: 14.r), // Thumb bisa tetap responsif
        
        // Menggunakan kembali custom shape untuk tick, yang paling penting
        tickMarkShape: const _CustomSliderTickMarkShape(tickRadius: 8), // Radius lebih kecil dari setengah trackHeight (4.25*2=8.5)

        overlayColor: Theme.of(context).colorScheme.primary.withAlpha(0x29),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0.r),
      ),
      child: Slider(
        min: 0.0,
        max: (_goalSteps.length - 1).toDouble(),
        divisions: _goalSteps.length - 1,
        value: _currentSliderIndex,
        onChanged: (value) {
          setState(() {
            _currentSliderIndex = value;
          });
        },
      ),
    );
  }
}
