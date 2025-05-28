import 'package:equatable/equatable.dart';

class UserMiniModel extends Equatable {
  const UserMiniModel({
    required this.id,
    required this.name,
    this.isFollowed = 0,
    this.isFollowing = 0,
    this.isFollower = 0,
    this.imagePath,
    this.imageUrl,
    this.isJoinedToClub = false,
  });

  final String id;
  final String name;
  final int isFollowed;
  final int isFollowing;
  final int isFollower;
  final String? imagePath;
  final String? imageUrl;
  final bool isJoinedToClub;

  UserMiniModel copyWith({
    String? id,
    String? name,
    int? isFollowed,
    int? isFollowing,
    int? isFollower,
    String? imagePath,
    String? imageUrl,
    bool? isJoinedToClub,
  }) {
    return UserMiniModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isFollowed: isFollowed ?? this.isFollowed,
      isFollowing: isFollowing ?? this.isFollowing,
      isFollower: isFollower ?? this.isFollower,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      isJoinedToClub: isJoinedToClub ?? this.isJoinedToClub,
    );
  }

  factory UserMiniModel.fromJson(Map<String, dynamic> json) {
    return UserMiniModel(
      id: json["id"],
      name: json["name"],
      isFollowed: json["is_followed"] ?? 0,
      isFollowing: json["is_following"] ?? 0,
      isFollower: json["is_follower"] ?? 0,
      imagePath: json["image_path"],
      imageUrl: json["image_url"],
      isJoinedToClub: json["is_joined_to_club"] != null
          ? (json["is_joined_to_club"] == 1)
          : false,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_followed": isFollowed,
        "is_following": isFollowing,
        "is_follower": isFollower,
        "image_path": imagePath,
        "image_url": imageUrl,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        isFollowed,
        isFollowing,
        isFollower,
        imagePath,
        imageUrl,
        isJoinedToClub,
      ];
}
