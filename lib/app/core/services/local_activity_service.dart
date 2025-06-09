import 'package:hive_flutter/hive_flutter.dart';
import 'package:zest_mobile/app/core/models/model/activity_data_point_model.dart';

class LocalActivityService {
  static const String _boxName = 'activity_tracking_box';

  // Buka box Hive
  Future<Box<ActivityDataPoint>> _openBox() async {
    return await Hive.openBox<ActivityDataPoint>(_boxName);
  }

  // Tambah satu titik data ke database
  Future<void> addDataPoint(ActivityDataPoint dataPoint) async {
    final box = await _openBox();
    // Gunakan timestamp sebagai key untuk memastikan keunikan dan bisa di-replace
    await box.put(dataPoint.timestamp.toIso8601String(), dataPoint);
  }

  // Ambil semua data poin
  Future<List<ActivityDataPoint>> getAllDataPoints() async {
    final box = await _openBox();
    return box.values.toList();
  }

  // Hapus semua data setelah sync berhasil
  Future<void> clearDataPoints() async {
    final box = await _openBox();
    await box.clear();
  }
}