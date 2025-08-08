// app/core/models/model/notification_model.dart
import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class NotificationModel extends Model<NotificationModel> {
  final String id;
  final String type; // e.g., "SYSTEM", "NEW_FOLLOWER", "ACTIVITY_LIKE"
  final Map<String, dynamic>? data;
  final DateTime? readAt;
  final DateTime? createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    this.data,
    required this.readAt,
    required this.createdAt,
  });
  
  // Implementasikan fromJson, copyWith, dll. sesuai kebutuhan
  
  @override
  List<Object?> get props => [id, type, data, readAt, createdAt];

  // copyWith
  @override
  NotificationModel copyWith({
    String? id,
    String? type,
    Map<String, dynamic>? data,
    DateTime? readAt,
    DateTime? createdAt,
  }) =>
    NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );

  
  // fromJson
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      data: json['data'],
      readAt: DateTime.tryParse(json['read_at'] ?? ''),
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    );
  }

  // toJson
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'data': data,
    'read_at': readAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
  };
}