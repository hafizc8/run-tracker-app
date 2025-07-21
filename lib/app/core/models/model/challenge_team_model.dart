import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class ChallengeTeamsModel extends Model {
  ChallengeTeamsModel({
    required this.id,
    required this.team,
    required this.isPendingJoin,
    required this.user,
  });

  final String? id;
  final String? team;
  final int? isPendingJoin;
  final User? user;

  @override
  ChallengeTeamsModel copyWith({
    String? id,
    String? team,
    int? isPendingJoin,
    User? user,
  }) {
    return ChallengeTeamsModel(
      id: id ?? this.id,
      team: team ?? this.team,
      isPendingJoin: isPendingJoin ?? this.isPendingJoin,
      user: user ?? this.user,
    );
  }

  factory ChallengeTeamsModel.fromJson(Map<String, dynamic> json) {
    return ChallengeTeamsModel(
      id: json["id"],
      team: json["team"],
      isPendingJoin: json["is_pending_join"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "team": team,
        "is_pending_join": isPendingJoin,
        "user": user?.toJson(),
      };

  @override
  String toString() {
    return "$id, $team, $isPendingJoin, $user, ";
  }

  @override
  List<Object?> get props => [
        id,
        team,
        isPendingJoin,
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
