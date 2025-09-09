import 'package:zest_mobile/app/core/models/enums/club_post_permission_enum.dart';
import 'package:zest_mobile/app/core/models/enums/club_privacy_enum.dart';
import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

// ignore: must_be_immutable
class ClubModel extends Model<ClubModel> {
  ClubModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.imagePath,
    required this.imageUrl,
    required this.country,
    required this.province,
    required this.district,
    required this.privacy,
    required this.privacyText,
    required this.postPermission,
    required this.postPermissionText,
    required this.createdAt,
    required this.eventsCount,
    required this.clubUsersCount,
    required this.challengeCount,
    this.isPendingJoin = false,
    this.isOwner = false,
    this.isJoined = false,
    this.isMember = false,
    this.friendsTotal,
    this.friendsNames,
    this.isMuted,
  });

  final String? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? imagePath;
  final String? imageUrl;
  final String? country;
  final String? province;
  final String? district;
  final ClubPrivacyEnum? privacy;
  final String? privacyText;
  final ClubPostPermissionEnum? postPermission;
  final String? postPermissionText;
  final DateTime? createdAt;
  final int? eventsCount;
  final int? clubUsersCount;
  final int? challengeCount;
  final bool? isPendingJoin;
  final bool? isJoined;
  final bool? isMember;
  bool? isOwner;
  int? friendsTotal;
  List<String>? friendsNames;
  final bool? isMuted;

  @override
  ClubModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? imagePath,
    String? imageUrl,
    String? country,
    String? province,
    String? district,
    ClubPrivacyEnum? privacy,
    String? privacyText,
    ClubPostPermissionEnum? postPermission,
    String? postPermissionText,
    DateTime? createdAt,
    int? eventsCount,
    int? clubUsersCount,
    int? challengeCount,
    bool? isPendingJoin,
    bool? isOwner,
    bool? isJoined,
    bool? isMember,
    int? friendsTotal,
    List<String>? friendsNames,
    bool? isMuted,
  }) {
    return ClubModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      country: country ?? this.country,
      province: province ?? this.province,
      district: district ?? this.district,
      privacy: privacy ?? this.privacy,
      privacyText: privacyText ?? this.privacyText,
      postPermission: postPermission ?? this.postPermission,
      postPermissionText: postPermissionText ?? this.postPermissionText,
      createdAt: createdAt ?? this.createdAt,
      eventsCount: eventsCount ?? this.eventsCount,
      clubUsersCount: clubUsersCount ?? this.clubUsersCount,
      challengeCount: challengeCount ?? this.challengeCount,
      isPendingJoin: isPendingJoin ?? this.isPendingJoin,
      isOwner: isOwner ?? this.isOwner,
      isJoined: isJoined ?? this.isJoined,
      isMember: isMember ?? this.isMember,
      friendsTotal: friendsTotal ?? this.friendsTotal,
      friendsNames: friendsNames ?? this.friendsNames,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      id: json["id"],
      name: json["name"],
      slug: json["slug"],
      description: json["description"],
      imagePath: json["image_path"],
      imageUrl: json["image_url"],
      country: json["country"],
      province: json["province"],
      district: json["district"],
      privacy: json["privacy"] != null
          ? ClubPrivacyEnum.fromValue(int.parse(json["privacy"].toString()))
          : null,
      privacyText: json["privacy_text"],
      postPermission: json["post_permission"] != null
          ? ClubPostPermissionEnum.fromValue(
              int.parse(json["post_permission"].toString()))
          : null,
      postPermissionText: json["post_permission_text"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      eventsCount: json["events_count"],
      clubUsersCount: json["club_users_count"],
      challengeCount: json["challenge_count"],
      isPendingJoin: json["is_pending_join"] == 1,
      isOwner: json["is_owner"] != null && json["is_owner"] == 1,
      isJoined: json["is_joined"] == 1,
      isMember: json["is_member"] == 1,
      friendsTotal: json["friends_total"],
      friendsNames: json["friends_names"] == null
          ? []
          : List<String>.from(json["friends_names"].map((x) => x)),
      isMuted: json["is_muted"] != null && json["is_muted"] == 1,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "description": description,
        "image_path": imagePath,
        "image_url": imageUrl,
        "country": country,
        "province": province,
        "district": district,
        "privacy": privacy,
        "privacy_text": privacyText,
        "post_permission": postPermission,
        "post_permission_text": postPermissionText,
        "created_at": createdAt?.toIso8601String(),
        "events_count": eventsCount,
        "club_users_count": clubUsersCount,
        "challenge_count": challengeCount,
        "is_pending_join": isPendingJoin == true ? 1 : 0,
        "is_owner": isOwner == true ? 1 : 0,
        "is_joined": isJoined == true ? 1 : 0,
        "is_member": isMember == true ? 1 : 0,
        "is_muted": isMuted == true ? 1 : 0
      };

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        description,
        imagePath,
        imageUrl,
        country,
        province,
        district,
        privacy,
        privacyText,
        postPermission,
        postPermissionText,
        createdAt,
        eventsCount,
        clubUsersCount,
        challengeCount,
        isPendingJoin,
        isOwner,
        isJoined,
        isMember,
        friendsTotal,
        friendsNames,
        isMuted
      ];
}
