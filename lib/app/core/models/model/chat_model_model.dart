import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class ChatModel extends Model {
  ChatModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  final String? id;
  final String? userId;
  final int? type;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  @override
  ChatModel copyWith({
    String? id,
    String? userId,
    int? type,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return ChatModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json["id"],
      userId: json["user_id"],
      type: json["type"],
      message: json["message"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "message": message,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };

  @override
  String toString() {
    return "$id, $userId, $type, $message, $createdAt, $updatedAt, $user, ";
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        message,
        createdAt,
        updatedAt,
        user,
      ];
}

class User extends Model {
  User({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.imageUrl,
  });

  final String? id;
  final String? name;
  final String? imagePath;
  final String? imageUrl;

  @override
  User copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? imageUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      imagePath: json["image_path"],
      imageUrl: json["image_url"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_path": imagePath,
        "image_url": imageUrl,
      };

  @override
  String toString() {
    return "$id, $name, $imagePath, $imageUrl, ";
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imagePath,
        imageUrl,
      ];
}
