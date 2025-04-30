import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

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
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      emailVerifiedAt: DateTime.tryParse(json["email_verified_at"] ?? ""),
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
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
    );
  }

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
      ];
}
