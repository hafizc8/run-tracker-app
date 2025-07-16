import 'package:zest_mobile/app/core/models/interface/model_interface.dart';
import 'package:zest_mobile/app/core/models/model/user_current_coin_model.dart';
import 'package:zest_mobile/app/core/models/model/user_current_stamina_model.dart';
import 'package:zest_mobile/app/core/models/model/user_current_xp_model.dart';
import 'package:zest_mobile/app/core/models/model/user_preference_model.dart';

class UserModel extends Model<UserModel> {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.province,
    required this.district,
    required this.subdistrict,
    required this.village,
    required this.postcode,
    required this.imagePath,
    required this.imageUrl,
    required this.birthday,
    required this.gender,
    required this.bio,
    required this.googleId,
    required this.googleToken,
    required this.facebookId,
    required this.facebookToken,
    required this.appleId,
    required this.appleToken,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,

    this.genderText,
    this.followersCount,
    this.followingCount,
    this.clubsCount,
    this.badgesCount,
    this.recordDailyStreakCount,
    this.userPreference,
    this.currentUserXp,
    this.currentUserStamina,
    this.currentUserCoin,
  });

  final String? id;
  final String? name;
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? latitude;
  final String? longitude;
  final String? country;
  final String? province;
  final String? district;
  final String? subdistrict;
  final String? village;
  final dynamic postcode;
  final String? imagePath;
  final String? imageUrl;
  final DateTime? birthday;
  final int? gender;
  final dynamic bio;
  final dynamic googleId;
  final dynamic googleToken;
  final dynamic facebookId;
  final dynamic facebookToken;
  final dynamic appleId;
  final dynamic appleToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;

  final String? genderText;
  final int? followersCount;
  final int? followingCount;
  final int? clubsCount;
  final int? badgesCount;
  final int? recordDailyStreakCount;
  final UserPreferenceModel? userPreference;
  final CurrentUserXpModel? currentUserXp;
  final CurrentUserStaminaModel? currentUserStamina;
  final CurrentUserCoinModel? currentUserCoin;

  @override
  UserModel copyWith({
    String? name,
    String? email,
    DateTime? emailVerifiedAt,
    String? latitude,
    String? longitude,
    String? country,
    String? province,
    String? district,
    String? subdistrict,
    String? village,
    dynamic postcode,
    String? imagePath,
    String? imageUrl,
    DateTime? birthday,
    int? gender,
    dynamic bio,
    dynamic googleId,
    dynamic googleToken,
    dynamic facebookId,
    dynamic facebookToken,
    dynamic appleId,
    dynamic appleToken,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,

    String? genderText,
    int? followersCount,
    int? followingCount,
    int? clubsCount,
    int? badgesCount,
    int? recordDailyStreakCount,
    UserPreferenceModel? userPreference,
    CurrentUserXpModel? currentUserXp,
    CurrentUserStaminaModel? currentUserStamina,
    CurrentUserCoinModel? currentUserCoin,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      province: province ?? this.province,
      district: district ?? this.district,
      subdistrict: subdistrict ?? this.subdistrict,
      village: village ?? this.village,
      postcode: postcode ?? this.postcode,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
      googleId: googleId ?? this.googleId,
      googleToken: googleToken ?? this.googleToken,
      facebookId: facebookId ?? this.facebookId,
      facebookToken: facebookToken ?? this.facebookToken,
      appleId: appleId ?? this.appleId,
      appleToken: appleToken ?? this.appleToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,

      genderText: genderText ?? this.genderText,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      clubsCount: clubsCount ?? this.clubsCount,
      badgesCount: badgesCount ?? this.badgesCount,
      recordDailyStreakCount: recordDailyStreakCount ?? this.recordDailyStreakCount,
      userPreference: userPreference ?? this.userPreference,
      currentUserXp: currentUserXp ?? this.currentUserXp,
      currentUserStamina: currentUserStamina ?? this.currentUserStamina,
      currentUserCoin: currentUserCoin ?? this.currentUserCoin,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? "",
      name: json["name"],
      email: json["email"],
      emailVerifiedAt: json["email_verified_at"] != null ? DateTime.tryParse(json["email_verified_at"]) : null,
      latitude: json["latitude"],
      longitude: json["longitude"],
      country: json["country"],
      province: json["province"],
      district: json["district"],
      subdistrict: json["subdistrict"],
      village: json["village"],
      postcode: json["postcode"],
      imagePath: json["image_path"],
      imageUrl: json["image_url"],
      birthday: DateTime.tryParse(json["birthday"] ?? ""),
      gender: json["gender"],
      bio: json["bio"],
      googleId: json["google_id"],
      googleToken: json["google_token"],
      facebookId: json["facebook_id"],
      facebookToken: json["facebook_token"],
      appleId: json["apple_id"],
      appleToken: json["apple_token"],
      createdAt: json["created_at"] != null ? DateTime.tryParse(json["created_at"]) : null,
      updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"]) : null,
      deletedAt: json["deleted_at"],

      genderText: json["gender_text"],
      followersCount: json["followers_count"],
      followingCount: json["following_count"],
      clubsCount: json["clubs_count"],
      badgesCount: json["badges_count"],
      recordDailyStreakCount: json["record_daily_streak_count"],
      userPreference: json["user_preference"] != null ? UserPreferenceModel.fromJson(json["user_preference"]) : null,
      currentUserXp: json["current_user_xp"] != null ? CurrentUserXpModel.fromJson(json["current_user_xp"]) : null,
      currentUserStamina: json["current_user_stamina"] != null ? CurrentUserStaminaModel.fromJson(json["current_user_stamina"]) : null,
      currentUserCoin: json["current_user_coin"] != null ? CurrentUserCoinModel.fromJson(json["current_user_coin"]) : null,
    );
  }

  String get address =>
      "$village, $subdistrict, $district, $province, $country";

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt?.toIso8601String(),
        "latitude": latitude,
        "longitude": longitude,
        "country": country,
        "province": province,
        "district": district,
        "subdistrict": subdistrict,
        "village": village,
        "postcode": postcode,
        "image_path": imagePath,
        "image_url": imageUrl,
        "birthday": birthday?.toIso8601String(),
        "gender": gender,
        "bio": bio,
        "google_id": googleId,
        "google_token": googleToken,
        "facebook_id": facebookId,
        "facebook_token": facebookToken,
        "apple_id": appleId,
        "apple_token": appleToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,

        "gender_text": genderText,
        "followers_count": followersCount,
        "following_count": followingCount,
        "clubs_count": clubsCount,
        "badges_count": badgesCount,
        "record_daily_streak_count": recordDailyStreakCount,
        "user_preference": userPreference?.toJson(),
        "current_user_xp": currentUserXp?.toJson(),
        "current_user_stamina": currentUserStamina?.toJson(),
        "current_user_coin": currentUserCoin?.toJson(),
      };

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        emailVerifiedAt,
        latitude,
        longitude,
        country,
        province,
        district,
        subdistrict,
        village,
        postcode,
        imagePath,
        imageUrl,
        birthday,
        gender,
        bio,
        googleId,
        googleToken,
        facebookId,
        facebookToken,
        appleId,
        appleToken,
        createdAt,
        updatedAt,
        deletedAt,

        genderText,
        followersCount,
        followingCount,
        clubsCount,
        badgesCount,
        recordDailyStreakCount,
        userPreference,
        currentUserXp,
        currentUserStamina,
        currentUserCoin,
      ];
}
