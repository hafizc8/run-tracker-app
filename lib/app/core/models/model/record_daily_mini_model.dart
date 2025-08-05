class RecordDailyMiniModel {
  final int step;
  final int calorie;
  final int time;
  final DateTime timestamp;

  RecordDailyMiniModel({
    required this.step,
    required this.calorie,
    required this.time,
    required this.timestamp,
  });

  // toJson
  Map<String, dynamic> toJson() => {
    'step': step,
    'calorie': calorie,
    'time': time,
    'timestamp': timestamp.toIso8601String(),
  };
}