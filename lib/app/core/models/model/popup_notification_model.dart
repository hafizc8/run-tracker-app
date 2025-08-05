import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class PopupNotificationModel extends Model<PopupNotificationModel> {
  PopupNotificationModel({
    this.id,
    this.type,
    this.typeText,
    this.title,
    this.imagePath,
    this.imageUrl,
    this.data,
    this.readAt,
    this.createdAt,
  });

  final String? id;
  final int? type;
  final String? typeText;
  final String? title;
  final String? imagePath;
  final String? imageUrl;
  final dynamic data;
  final DateTime? readAt;
  final DateTime? createdAt;

  @override
  PopupNotificationModel copyWith({
    String? id,
    int? type,
    String? typeText,
    String? title,
    String? imagePath,
    String? imageUrl,
    dynamic data,
    DateTime? readAt,
    DateTime? createdAt,
  }) {
    return PopupNotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      typeText: typeText ?? this.typeText,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PopupNotificationModel.fromJson(Map<String, dynamic> json) {
    return PopupNotificationModel(
      id: json["id"],
      type: json["type"],
      typeText: json["type_text"],
      title: json["title"],
      imagePath: json["image_path"],
      imageUrl: json["image_url"],
      data: json["data"],
      readAt: json["read_at"] == null ? null : DateTime.tryParse(json["read_at"]),
      createdAt: json["created_at"] == null ? null : DateTime.tryParse(json["created_at"]),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "type_text": typeText,
        "title": title,
        "image_path": imagePath,
        "image_url": imageUrl,
        "data": data,
        "read_at": readAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        type,
        typeText,
        title,
        imagePath,
        imageUrl,
        data,
        readAt,
        createdAt,
      ];
}