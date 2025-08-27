import 'package:zest_mobile/app/core/models/interface/model_interface.dart';
import 'package:zest_mobile/app/core/models/model/badge_model.dart';
import 'package:zest_mobile/app/core/models/model/user_current_xp_model.dart';

class UserDetailModel extends Model {
  UserDetailModel({
    required this.id,
    required this.name,
    required this.country,
    required this.province,
    required this.district,
    required this.subdistrict,
    required this.village,
    required this.postcode,
    required this.imagePath,
    required this.imageUrl,
    required this.gender,
    required this.genderText,
    required this.bio,
    required this.isFollower,
    required this.isFollowed,
    required this.isFollowing,
    required this.followersCount,
    required this.followingCount,
    required this.clubsCount,
    required this.badgesCount,
    required this.badges,
    required this.overallMileage,
    this.currentUserXp,
    this.recordActivitiesCount,
  });

  final dynamic id;
  final String? name;
  final String? country;
  final String? province;
  final String? district;
  final String? subdistrict;
  final String? village;
  final dynamic postcode;
  final dynamic imagePath;
  final dynamic imageUrl;
  final int? gender;
  final String? genderText;
  final dynamic bio;
  final int? isFollower;
  final int? isFollowed;
  final int? isFollowing;
  final int? followersCount;
  final int? followingCount;
  final int? clubsCount;
  final int? badgesCount;
  final int? recordActivitiesCount;
  final List<BadgeModel> badges;
  final int? overallMileage;
  final CurrentUserXpModel? currentUserXp;

  @override
  UserDetailModel copyWith({
    dynamic? id,
    String? name,
    String? country,
    String? province,
    String? district,
    String? subdistrict,
    String? village,
    dynamic? postcode,
    dynamic? imagePath,
    dynamic? imageUrl,
    int? gender,
    String? genderText,
    dynamic? bio,
    int? isFollower,
    int? isFollowed,
    int? isFollowing,
    int? followersCount,
    int? followingCount,
    int? clubsCount,
    int? badgesCount,
    List<BadgeModel>? badges,
    int? overallMileage,
    CurrentUserXpModel? currentUserXp,
    int? recordActivitiesCount,
  }) {
    return UserDetailModel(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      province: province ?? this.province,
      district: district ?? this.district,
      subdistrict: subdistrict ?? this.subdistrict,
      village: village ?? this.village,
      postcode: postcode ?? this.postcode,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
      genderText: genderText ?? this.genderText,
      bio: bio ?? this.bio,
      isFollower: isFollower ?? this.isFollower,
      isFollowed: isFollowed ?? this.isFollowed,
      isFollowing: isFollowing ?? this.isFollowing,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      clubsCount: clubsCount ?? this.clubsCount,
      badgesCount: badgesCount ?? this.badgesCount,
      badges: badges ?? this.badges,
      overallMileage: overallMileage ?? this.overallMileage,
      currentUserXp: currentUserXp ?? this.currentUserXp,
      recordActivitiesCount:
          recordActivitiesCount ?? this.recordActivitiesCount,
    );
  }

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      id: json["id"],
      name: json["name"],
      country: json["country"],
      province: json["province"],
      district: json["district"],
      subdistrict: json["subdistrict"],
      village: json["village"],
      postcode: json["postcode"],
      imagePath: json["image_path"],
      imageUrl: json["image_url"],
      gender: json["gender"],
      genderText: json["gender_text"],
      bio: json["bio"],
      isFollower: json["is_follower"],
      isFollowed: json["is_followed"],
      isFollowing: json["is_following"],
      followersCount: json["followers_count"],
      followingCount: json["following_count"],
      clubsCount: json["clubs_count"],
      badgesCount: json["badges_count"],
      badges: json["badges"] == null
          ? []
          : List<BadgeModel>.from(
              json["badges"]!.map((x) => BadgeModel.fromJson(x))),
      overallMileage: json["overall_mileage"],
      currentUserXp: json["current_user_xp"] == null
          ? null
          : CurrentUserXpModel.fromJson(json["current_user_xp"]),
      recordActivitiesCount: json["record_activities_count"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country": country,
        "province": province,
        "district": district,
        "subdistrict": subdistrict,
        "village": village,
        "postcode": postcode,
        "image_path": imagePath,
        "image_url": imageUrl,
        "gender": gender,
        "gender_text": genderText,
        "bio": bio,
        "is_follower": isFollower,
        "is_followed": isFollowed,
        "is_following": isFollowing,
        "followers_count": followersCount,
        "following_count": followingCount,
        "clubs_count": clubsCount,
        "badges_count": badgesCount,
        "badges": badges.map((x) => x.toJson()).toList(),
        "current_user_xp": currentUserXp?.toJson(),
        "overall_mileage": overallMileage,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        country,
        province,
        district,
        subdistrict,
        village,
        postcode,
        imagePath,
        imageUrl,
        gender,
        genderText,
        bio,
        isFollower,
        isFollowed,
        isFollowing,
        followersCount,
        followingCount,
        clubsCount,
        badgesCount,
        badges,
        overallMileage,
        currentUserXp,
        recordActivitiesCount,
      ];
}
