// app/core/services/log_service.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

// Enum untuk level log, agar lebih terstruktur
enum LogLevel { verbose, debug, info, warning, error }

class ReleaseLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

class LogService extends GetxService {
  late final Logger _logger;
  late final String _logFilePath;

  Logger get log => _logger;

  Future<LogService> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _logFilePath = '${directory.path}/activity_logs.txt';
    final logFile = File(_logFilePath);

    // ✨ KUNCI PERBAIKAN: Konfigurasi printer agar outputnya bersih ✨
    _logger = Logger(
      filter: ReleaseLogFilter(),
      printer: PrettyPrinter(
        methodCount: 1,       // Tampilkan 1 method di stack trace
        dateTimeFormat: DateTimeFormat.dateAndTime,
        colors: false,        // PENTING: Matikan warna agar tidak ada ANSI codes
        printEmojis: false,    // Matikan emoji untuk kebersihan
        lineLength: 60,      // Atur panjang baris
      ),
      output: MultiOutput([
        // Output ini sekarang akan menerima teks yang sudah bersih
        FileOutput(file: logFile, overrideExisting: true),
        // ConsoleOutput juga akan menampilkan log tanpa warna, tapi tetap rapi
        if (kDebugMode) ConsoleOutput(),
      ]),
    );
    
    log.i("✅ LogService Initialized. Logging to file: $_logFilePath");
    return this;
  }

  // Method untuk mencatat log dari background service
  void logFromBackground(Map<String, dynamic> data) {
    final level = LogLevel.values.firstWhere(
      (e) => e.toString() == data['level'],
      orElse: () => LogLevel.info,
    );
    final message = "[BG] ${data['message']}";
    final error = data['error'];
    
    switch (level) {
      case LogLevel.verbose:
        log.v(message, error: error);
        break;
      case LogLevel.debug:
        log.d(message, error: error);
        break;
      case LogLevel.warning:
        log.w(message, error: error);
        break;
      case LogLevel.error:
        log.e(message, error: error);
        break;
      default:
        log.i(message, error: error);
    }
  }

  Future<void> exportLogs() async {
    try {
      final logFile = XFile(_logFilePath);
      await Share.shareXFiles([logFile], text: 'Zest+ Activity Logs');
      log.i("Log file has been shared.");
    } catch (e) {
      log.e("Failed to share log file", error: e);
    }
  }

  // ✨ --- FUNGSI BARU DITAMBAHKAN --- ✨

  /// Membaca semua konten dari file log sebagai sebuah String.
  Future<String> readLogs() async {
    try {
      final file = File(_logFilePath);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return "Log file not found.";
    } catch (e) {
      return "Error reading log file: $e";
    }
  }

  /// Menghapus semua konten dari file log.
  Future<void> clearLogs() async {
    try {
      final file = File(_logFilePath);
      if (await file.exists()) {
        // Menimpa file dengan string kosong untuk menghapus konten
        await file.writeAsString('');
        log.w("Log file has been cleared by user."); // Catat aksi ini
        Get.snackbar("Success", "Log file has been cleared.");
      }
    } catch (e) {
      log.e("Failed to clear log file", error: e);
    }
  }
}