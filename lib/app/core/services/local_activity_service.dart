import 'package:hive_flutter/hive_flutter.dart';
import 'package:zest_mobile/app/core/models/model/activity_data_point_model.dart';

class LocalActivityService {
  static const String _dataPointsBoxName = 'activity_data_points_box';
  static const String _sessionBoxName = 'unsynced_session_box';
  static const String _sessionKey = 'current_session';

  // --- Data Points Box Operations ---
  Future<Box<ActivityDataPoint>> _openDataPointsBox() async {
    return await Hive.openBox<ActivityDataPoint>(_dataPointsBoxName);
  }

  Future<void> addDataPoint(ActivityDataPoint dataPoint) async {
    final box = await _openDataPointsBox();
    await box.put(dataPoint.timestamp.toIso8601String(), dataPoint);
  }

  Future<List<ActivityDataPoint>> getAllDataPoints() async {
    final box = await _openDataPointsBox();
    return box.values.toList();
  }

  Future<void> clearDataPoints() async {
    final box = await _openDataPointsBox();
    await box.clear();
  }

  // --- ✨ BARU: Session Box Operations ---
  Future<Box> _openSessionBox() async {
    return await Hive.openBox(_sessionBoxName);
  }

  /// Menyimpan data sesi yang belum disinkronkan ke database lokal.
  Future<void> saveUnsyncedSession(Map<String, dynamic> sessionData) async {
    final box = await _openSessionBox();
    await box.put(_sessionKey, sessionData);
  }

  /// Mengambil data sesi yang belum disinkronkan. Mengembalikan null jika tidak ada.
  Future<Map<String, dynamic>?> getUnsyncedSession() async {
    final box = await _openSessionBox();
    final data = box.get(_sessionKey);
    if (data != null && data is Map) {
      // Pastikan semua keys ada dan tipenya benar
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  /// Menghapus data sesi yang tersimpan.
  Future<void> clearSessionData() async {
    final box = await _openSessionBox();
    await box.clear();
  }

  // --- ✨ BARU: Combined Clear Operation ---

  /// Menghapus SEMUA data yang belum disinkronkan (data points dan session).
  Future<void> clearAllUnsyncedData() async {
    await clearDataPoints();
    await clearSessionData();
  }
}