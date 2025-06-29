import 'dart:async';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/services/log_service.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class DebugController extends GetxController {
  final LogService _logService = sl<LogService>();
  
  // State untuk menampilkan info aplikasi
  var appVersion = '...'.obs;

  // Logika untuk pemicu tersembunyi
  var _tapCount = 0;
  Timer? _tapTimer;

  var logContent = 'Loading logs...'.obs;


  @override
  void onInit() {
    super.onInit();
    _loadAppVersion();
  }

  void onDebugViewReady() {
    refreshLogs();
  }

  /// Memuat ulang konten log dari file ke state.
  Future<void> refreshLogs() async {
    logContent.value = "Reading logs...";
    logContent.value = await _logService.readLogs();
  }

  /// Menghapus log dan langsung memuat ulang tampilannya.
  Future<void> clearAndRefreshLogs() async {
    await _logService.clearLogs();
    await refreshLogs();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = 'Version ${packageInfo.version} (${packageInfo.buildNumber})';
    } catch (e) {
      appVersion.value = 'Version not found';
    }
  }

  // Method yang akan dipanggil saat versi aplikasi di-tap
  void onVersionTap() {
    _tapTimer?.cancel();
    _tapTimer = Timer(const Duration(seconds: 3), () {
      _tapCount = 0; // Reset hitungan jika jeda lebih dari 3 detik
      print("Debug tap count reset.");
    });

    _tapCount++;
    print("Debug tap count: $_tapCount");

    // Jika di-tap 7 kali, buka halaman log
    if (_tapCount >= 7) {
      _tapCount = 0;
      _tapTimer?.cancel();
      Get.toNamed(AppRoutes.logViewer); // Gunakan nama route yang akan kita buat
    }
  }
}