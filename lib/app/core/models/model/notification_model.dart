// app/core/models/model/notification_model.dart
import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class NotificationModel extends Model<NotificationModel> {
  final String id;
  final String type; // e.g., "SYSTEM", "NEW_FOLLOWER", "ACTIVITY_LIKE"
  final String title;
  final String message;
  final String? imageUrl;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic>? payload;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.imageUrl,
    required this.isRead,
    required this.createdAt,
    this.payload,
  });
  
  // Implementasikan fromJson, copyWith, dll. sesuai kebutuhan
  
  @override
  List<Object?> get props => [id, isRead];

  // copyWith
  @override
  NotificationModel copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    String? imageUrl,
    bool? isRead,
    DateTime? createdAt,
    Map<String, dynamic>? payload,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        type: type ?? this.type,
        title: title ?? this.title,
        message: message ?? this.message,
        imageUrl: imageUrl ?? this.imageUrl,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt ?? this.createdAt,
        payload: payload ?? this.payload,
      );

  
  // fromJson
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      imageUrl: json['image_url'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
      payload: json['payload'],
    );
  }

  // toJson
  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'message': message,
    'image_url': imageUrl,
    'is_read': isRead,
    'created_at': createdAt.toIso8601String(),
    'payload': payload,
  };
}