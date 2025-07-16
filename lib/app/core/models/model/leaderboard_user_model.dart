import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class LeaderboardUserModel extends Model<LeaderboardUserModel> {
  LeaderboardUserModel({
    this.rank,
    this.id,
    this.name,
    this.imagePath,
    this.imageUrl,
    this.totalStep,
  });

  final int? rank;
  final String? id;
  final String? name;
  final String? imagePath;
  final String? imageUrl;
  final int? totalStep;

  @override
  LeaderboardUserModel copyWith({
    int? rank,
    String? id,
    String? name,
    String? imagePath,
    String? imageUrl,
    int? totalStep,
  }) {
    return LeaderboardUserModel(
      rank: rank ?? this.rank,
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      totalStep: totalStep ?? this.totalStep,
    );
  }

  factory LeaderboardUserModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardUserModel(
      rank: json["rank"],
      id: json["id"],
      name: json["name"],
      imagePath: json["image_path"],
      imageUrl: json["image_url"],
      totalStep: json["total_step"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "rank": rank,
        "id": id,
        "name": name,
        "image_path": imagePath,
        "image_url": imageUrl,
        "total_step": totalStep,
      };

  @override
  List<Object?> get props => [rank, id, name, imageUrl, totalStep];
}
