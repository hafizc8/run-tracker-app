import 'package:hive/hive.dart';

part 'activity_data_point_model.g.dart'; // File ini akan digenerate

@HiveType(typeId: 1) // ID harus unik untuk setiap model
class ActivityDataPoint extends HiveObject {

  @HiveField(0)
  final double latitude;

  @HiveField(1)
  final double longitude;

  @HiveField(2)
  final int step;

  @HiveField(3)
  final double distance;

  @HiveField(4)
  final double pace;

  @HiveField(5)
  final int time; // Durasi dalam detik

  @HiveField(6)
  final DateTime timestamp;

  ActivityDataPoint({
    required this.latitude,
    required this.longitude,
    required this.step,
    required this.distance,
    required this.pace,
    required this.time,
    required this.timestamp,
  });

  // Helper untuk mengubah objek menjadi Map (berguna untuk konversi ke JSON)
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'step': step,
      'distance': distance,
      'pace': pace,
      'time': time,
      'timestamp': timestamp.toIso8601String().substring(0, 19).replaceFirst('T', ' '),
    };
  }
}