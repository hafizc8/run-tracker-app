import 'dart:math';
import 'package:flutter/material.dart';

class SlideToAction extends StatefulWidget {
  /// Callback yang dipanggil saat slider berhasil digeser hingga akhir.
  final VoidCallback onSubmit;

  /// Tinggi dari track latar belakang slider.
  final double trackHeight;

  /// Tinggi dan lebar dari thumb slider (bagian yang digeser).
  final double thumbHeight;

  /// Teks yang ditampilkan di tengah track.
  final String text;

  /// Gaya teks.
  final TextStyle? textStyle;

  /// Ikon yang ditampilkan di dalam thumb.
  final Widget sliderIcon;
  
  /// Warna area track yang belum tergeser.
  final Color inactiveTrackColor;

  /// Gradient untuk area track yang sudah tergeser dan untuk thumb.
  final Gradient activeTrackGradient;

  /// Durasi animasi saat slider kembali ke posisi awal.
  final Duration snapBackDuration;

  /// Border radius untuk track dan thumb.
  final double borderRadius;

  const SlideToAction({
    super.key,
    required this.onSubmit,
    this.trackHeight = 60,
    this.thumbHeight = 70, // Sedikit lebih besar dari trackHeight
    this.text = 'Start Your Zest+!',
    this.textStyle,
    this.sliderIcon = const Icon(Icons.double_arrow, color: Colors.black),
    this.inactiveTrackColor = const Color(0xFF2E2E2E),
    this.activeTrackGradient = const LinearGradient(
      colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    this.snapBackDuration = const Duration(milliseconds: 200),
    this.borderRadius = 16.0,
  });

  @override
  State<SlideToAction> createState() => _SlideToActionState();
}

class _SlideToActionState extends State<SlideToAction> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _sliderPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.snapBackDuration,
    );
    _animationController.addListener(() {
      setState(() {
        _sliderPosition = _animationController.value;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, double maxPosition) {
    setState(() {
      _sliderPosition = (_sliderPosition + details.delta.dx).clamp(0.0, maxPosition);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details, double maxPosition) {
    if (_sliderPosition > maxPosition * 0.85) {
      setState(() {
        _sliderPosition = maxPosition;
      });
      widget.onSubmit();
    }

    _animationController.value = _sliderPosition / maxPosition;
    _animationController.reverse(from: _sliderPosition / maxPosition);
  }

  Widget _buildSliderThumb() {
    return Stack(
      clipBehavior: Clip.none, // Izinkan efek tumpukan keluar dari batas
      children: [
        // Transform.translate(
        //   offset: const Offset(-8, -5),
        //   child: Container(
        //     width: widget.thumbHeight,
        //     height: widget.thumbHeight,
        //     decoration: BoxDecoration(
        //       gradient: widget.activeTrackGradient,
        //       borderRadius: BorderRadius.circular(widget.borderRadius + 2),
        //     ),
        //   ),
        // ),
        Container(
          width: widget.thumbHeight,
          height: widget.thumbHeight,
          decoration: BoxDecoration(
            gradient: widget.activeTrackGradient,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Center(child: widget.sliderIcon),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double trackWidth = constraints.maxWidth;
        final double thumbWidth = widget.thumbHeight; // Lebar thumb sama dengan tingginya
        final double maxPosition = trackWidth - thumbWidth;
        final double activeTrackWidth = _sliderPosition + thumbWidth / 2;

        return GestureDetector(
          onHorizontalDragUpdate: (details) => _onHorizontalDragUpdate(details, maxPosition),
          onHorizontalDragEnd: (details) => _onHorizontalDragEnd(details, maxPosition),
          child: SizedBox(
            width: trackWidth,
            height: thumbWidth, // ✅ Widget utama setinggi thumb yang lebih besar
            child: Stack(
              clipBehavior: Clip.none, // ✅ Izinkan thumb digambar di luar batas Stack
              alignment: Alignment.center, // Pusatkan semua anak secara vertikal
              children: [
                // --- Latar Belakang Track ---
                Container(
                  width: trackWidth,
                  height: widget.trackHeight, // ✅ Track lebih pendek dari thumb
                  decoration: BoxDecoration(
                    color: widget.inactiveTrackColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: ClipRRect( // ClipRRect untuk konten di dalam track
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: Stack(
                      children: [
                        // Area Aktif (Gradient)
                        Positioned(
                          left: 0, top: 0, bottom: 0,
                          child: Container(
                            width: activeTrackWidth,
                            decoration: BoxDecoration(
                              gradient: widget.activeTrackGradient,
                            ),
                          ),
                        ),
                        // Teks di Tengah
                        Center(
                          child: Opacity(
                            opacity: max(0.0, 1.0 - (_sliderPosition / maxPosition) * 2),
                            child: Text(
                              widget.text,
                              style: widget.textStyle ??
                                  TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- Thumb Slider ---
                Positioned(
                  left: _sliderPosition,
                  // Tidak perlu 'top' karena Stack alignment: Alignment.center
                  // akan menengahkan thumb secara vertikal.
                  child: _buildSliderThumb(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}