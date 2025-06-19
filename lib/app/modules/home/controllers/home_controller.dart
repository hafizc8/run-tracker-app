import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';

class HomeController extends GetxController {
  final RxInt _currentSteps = 0.obs;
  int get currentSteps => _currentSteps.value;

  final int maxSteps = 30000;

  final RxString _error = ''.obs;
  String get error => _error.value;

  late StreamSubscription<StepCount> _stepCountSubscription;

  @override
  void onInit() {
    super.onInit();
    _initPedometer();
  }

  @override
  void onClose() {
    _stepCountSubscription.cancel();
    super.onClose();
  }

  void _initPedometer() {
    try {
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        (StepCount event) {
          _currentSteps.value = event.steps;
          if (_error.isNotEmpty) {
            _error.value = '';
          }
        },
        onError: (error) {
          _error.value = 'Step Sensor Not Available or Permission Denied';
          print('Pedometer Error: $error');
        },
        cancelOnError: true,
      );
    } catch (e) {
      _error.value = 'Gagal menginisialisasi pedometer.';
      print('Error initializing pedometer: $e');
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    }
  }

  double get progressValue => (currentSteps / maxSteps).clamp(0.0, 1.0);






  // For icon streak
  final iconPosition = const Offset(20, 100).obs;

  final double iconSize = 26.0;
  final double margin = 18.0;

  // Method untuk memperbarui posisi ikon saat digeser
  void updateIconPosition(DragUpdateDetails details, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final safeArea = MediaQuery.of(context).padding;

    double newDx = iconPosition.value.dx + details.delta.dx;
    double newDy = iconPosition.value.dy + details.delta.dy;

    // Batasi gerakan agar tidak keluar dari layar (Clamping)
    newDx = newDx.clamp(margin, screenSize.width - iconSize - margin);
    newDy = newDy.clamp(
      safeArea.top + margin, // Mulai dari bawah AppBar/Notch
      screenSize.height - iconSize - margin - safeArea.bottom,
    );
    
    // Perbarui nilai .value dari Rx<Offset>
    iconPosition.value = Offset(newDx, newDy);
  }

  // Method untuk menempelkan ikon ke tepi saat geseran selesai
  void snapIconToEdge(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double currentDx = iconPosition.value.dx;
    double currentDy = iconPosition.value.dy;

    if (currentDx < (screenSize.width - iconSize) / 2) {
      // Jika lebih dekat ke kiri, tempelkan ke kiri
      iconPosition.value = Offset(margin, currentDy);
    } else {
      // Jika lebih dekat ke kanan, tempelkan ke kanan
      iconPosition.value = Offset(screenSize.width - iconSize - margin, currentDy);
    }
  }
}
