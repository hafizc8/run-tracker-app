import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
          _error.value = 'Sensor tidak ditemukan atau izin ditolak.';
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
}
