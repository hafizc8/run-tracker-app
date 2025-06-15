import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class RecordActivityModel extends Model {
  RecordActivityModel({
    required this.id,
    required this.userId,
    required this.startDatetime,
    required this.endDatetime,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.province,
    required this.district,
    required this.subdistrict,
    required this.village,
    required this.postcode,
    required this.createdAt,
    required this.recordActivityLogs,
    this.recordActivityLogsAvgPace,
    this.recordActivityLogsSumDistance,
    this.recordActivityLogsSumTime,
    this.recordActivityLogsSumStep,
  });

  final String? id;
  final String? userId;
  final DateTime? startDatetime;
  final DateTime? endDatetime;
  final double? latitude;
  final double? longitude;
  final String? country;
  final String? province;
  final String? district;
  final String? subdistrict;
  final String? village;
  final String? postcode;
  final DateTime? createdAt;
  final List<RecordActivityLogModel> recordActivityLogs;
  double? recordActivityLogsAvgPace;
  double? recordActivityLogsSumDistance;
  int? recordActivityLogsSumTime;
  int? recordActivityLogsSumStep;

  RecordActivityModel copyWith({
    String? id,
    String? userId,
    DateTime? startDatetime,
    DateTime? endDatetime,
    double? latitude,
    double? longitude,
    String? country,
    String? province,
    String? district,
    String? subdistrict,
    String? village,
    String? postcode,
    DateTime? createdAt,
    List<RecordActivityLogModel>? recordActivityLogs,
    double? recordActivityLogsAvgPace,
    double? recordActivityLogsSumDistance,
    int? recordActivityLogsSumTime,
    int? recordActivityLogsSumStep,
  }) {
    return RecordActivityModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDatetime: startDatetime ?? this.startDatetime,
      endDatetime: endDatetime ?? this.endDatetime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      province: province ?? this.province,
      district: district ?? this.district,
      subdistrict: subdistrict ?? this.subdistrict,
      village: village ?? this.village,
      postcode: postcode ?? this.postcode,
      createdAt: createdAt ?? this.createdAt,
      recordActivityLogs: recordActivityLogs ?? this.recordActivityLogs,
      recordActivityLogsAvgPace: recordActivityLogsAvgPace ?? this.recordActivityLogsAvgPace,
      recordActivityLogsSumDistance: recordActivityLogsSumDistance ?? this.recordActivityLogsSumDistance,
      recordActivityLogsSumTime: recordActivityLogsSumTime ?? this.recordActivityLogsSumTime,
      recordActivityLogsSumStep: recordActivityLogsSumStep ?? this.recordActivityLogsSumStep,
    );
  }

  factory RecordActivityModel.fromJson(Map<String, dynamic> json) {
    return RecordActivityModel(
      id: json["id"],
      userId: json["user_id"],
      startDatetime: DateTime.tryParse(json["start_datetime"] ?? ""),
      endDatetime: DateTime.tryParse(json["end_datetime"] ?? ""),
      latitude: double.tryParse(json["latitude"] ?? "0.0"),
      longitude: double.tryParse(json["longitude"] ?? "0.0"),
      country: json["country"],
      province: json["province"],
      district: json["district"],
      subdistrict: json["subdistrict"],
      village: json["village"],
      postcode: json["postcode"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      recordActivityLogs: json["record_activity_logs"] == null
          ? []
          : List<RecordActivityLogModel>.from(json["record_activity_logs"]!.map((x) => RecordActivityLogModel.fromJson(x))),
      recordActivityLogsAvgPace: json["record_activity_logs_avg_pace"] == null ? null : double.parse(json["record_activity_logs_avg_pace"]),
      recordActivityLogsSumDistance: json["record_activity_logs_sum_distance"] == null ? null : double.parse(json["record_activity_logs_sum_distance"]),
      recordActivityLogsSumTime: json["record_activity_logs_sum_time"] == null ? null : int.parse(json["record_activity_logs_sum_time"]),
      recordActivityLogsSumStep: json["record_activity_logs_sum_step"] == null ? null : int.parse(json["record_activity_logs_sum_step"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "start_datetime": startDatetime != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(startDatetime!) : null,
        "end_datetime": endDatetime != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(endDatetime!) : null,
        "latitude": latitude?.toString(),
        "longitude": longitude?.toString(),
        "country": country,
        "province": province,
        "district": district,
        "subdistrict": subdistrict,
        "village": village,
        "postcode": postcode,
        "created_at": createdAt?.toIso8601String(),
        "record_activity_logs": recordActivityLogs.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        startDatetime,
        endDatetime,
        latitude,
        longitude,
        country,
        province,
        district,
        subdistrict,
        village,
        postcode,
        createdAt,
        recordActivityLogs,
        recordActivityLogsAvgPace,
        recordActivityLogsSumDistance,
        recordActivityLogsSumTime,
        recordActivityLogsSumStep,
      ];
}

class RecordActivityLogModel extends Model {
  RecordActivityLogModel({
    required this.id,
    required this.recordActivityId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.pace,
    required this.distance,
    required this.time,
  });

  final String? id;
  final String? recordActivityId;
  final DateTime? timestamp;
  final double? latitude;
  final double? longitude;
  final double? pace;
  final double? distance;
  final int? time;

  RecordActivityLogModel copyWith({
    String? id,
    String? recordActivityId,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    double? pace,
    double? distance,
    int? time,
  }) {
    return RecordActivityLogModel(
      id: id ?? this.id,
      recordActivityId: recordActivityId ?? this.recordActivityId,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      pace: pace ?? this.pace,
      distance: distance ?? this.distance,
      time: time ?? this.time,
    );
  }

  factory RecordActivityLogModel.fromJson(Map<String, dynamic> json) {
    return RecordActivityLogModel(
      id: json["id"],
      recordActivityId: json["record_activity_id"],
      timestamp: DateTime.tryParse(json["timestamp"] ?? ""),
      latitude: double.tryParse(json["latitude"] ?? "0.0"),
      longitude: double.tryParse(json["longitude"] ?? "0.0"),
      pace: double.tryParse(json["pace"].toString()) ?? 0.0,
      distance: double.tryParse(json["distance"] ?? "0.0"),
      time: json["time"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "record_activity_id": recordActivityId,
        "timestamp": timestamp != null ? DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp!) : null,
        "latitude": latitude?.toString(),
        "longitude": longitude?.toString(),
        "pace": pace?.toStringAsFixed(2),
        "distance": distance?.toStringAsFixed(2),
        "time": time,
      };

  @override
  List<Object?> get props => [
        id,
        recordActivityId,
        timestamp,
        latitude,
        longitude,
        pace,
        distance,
        time,
      ];
}