import 'package:equatable/equatable.dart';

class UserMiniModel extends Equatable {
  const UserMiniModel({
    required this.id,
    required this.name,
    this.isFollowed = 0,
    this.isFollowing = 0,
    this.imagePath,
    this.imageUrl,
  });

  final String id;
  final String name;
  final int isFollowed;
  final int isFollowing;
  final String? imagePath;
  final String? imageUrl;

  UserMiniModel copyWith({
    String? id,
    String? name,
    int? isFollowed,
    int? isFollowing,
    String? imagePath,
    String? imageUrl,
  }) {
    return UserMiniModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isFollowed: isFollowed ?? this.isFollowed,
      isFollowing: isFollowing ?? this.isFollowing,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory UserMiniModel.fromJson(Map<String, dynamic> json) {
    return UserMiniModel(
      id: json["id"],
      name: json["name"],
      isFollowed: json["is_followed"],
      isFollowing: json["is_following"],
      imagePath: json["image_path"],
      imageUrl: json["image_url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_followed": isFollowed,
        "is_following": isFollowing,
        "image_path": imagePath,
        "image_url": imageUrl,
      };

  @override
  String toString() {
    return "$id, $name, $imagePath, $imageUrl, $isFollowed, $isFollowing";
  }

  @override
  List<Object?> get props => [
        id,
        name,
        isFollowed,
        isFollowing,
        imagePath,
        imageUrl,
      ];
}
