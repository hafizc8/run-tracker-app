import 'package:equatable/equatable.dart';

class UserMiniModel extends Equatable {
  const UserMiniModel({
    required this.id,
    required this.name,
    this.imagePath,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String? imagePath;
  final String? imageUrl;

  UserMiniModel copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? imageUrl,
  }) {
    return UserMiniModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory UserMiniModel.fromJson(Map<String, dynamic> json) {
    return UserMiniModel(
      id: json["id"],
      name: json["name"],
      imagePath: json["image_path"],
      imageUrl: json["image_url"],
    );
  }

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
