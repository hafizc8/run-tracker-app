import 'package:equatable/equatable.dart';
import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class ChatInboxModel extends Model {
  ChatInboxModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.relateableUser,
    required this.relateableClub,
    required this.relateableEvent,
  });

  final String? id;
  final String? userId;
  final int? type;
  final String? message;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final RelateableUser? relateableUser;
  final RelateableClub? relateableClub;
  final RelateableEvent? relateableEvent;

  @override
  ChatInboxModel copyWith({
    String? id,
    String? userId,
    int? type,
    String? message,
    DateTime? createdAt,
    DateTime? updatedAt,
    RelateableUser? relateableUser,
    RelateableClub? relateableClub,
    RelateableEvent? relateableEvent,
  }) {
    return ChatInboxModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      relateableUser: relateableUser ?? this.relateableUser,
      relateableClub: relateableClub ?? this.relateableClub,
      relateableEvent: relateableEvent ?? this.relateableEvent,
    );
  }

  factory ChatInboxModel.fromJson(Map<String, dynamic> json) {
    return ChatInboxModel(
      id: json["id"],
      userId: json["user_id"],
      type: json["type"],
      message: json["message"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      relateableUser: json["relateable_user"] == null
          ? null
          : RelateableUser.fromJson(json["relateable_user"]),
      relateableClub: json["relateable_club"] == null
          ? null
          : RelateableClub.fromJson(json["relateable_club"]),
      relateableEvent: json["relateable_event"] == null
          ? null
          : RelateableEvent.fromJson(json["relateable_event"]),
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
        "relateable_user": relateableUser?.toJson(),
        "relateable_club": relateableClub?.toJson(),
        "relateable_event": relateableEvent?.toJson(),
      };

  @override
  String toString() {
    return "$id, $userId, $type, $message, $createdAt, $updatedAt, $relateableUser, $relateableClub, $relateableEvent, ";
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        message,
        createdAt,
        updatedAt,
        relateableUser,
        relateableClub,
        relateableEvent,
      ];
}

class RelateableClub extends Model {
  RelateableClub({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.imagePath,
    required this.country,
    required this.province,
    required this.district,
    required this.privacy,
    required this.postPermission,
    required this.createdAt,
    required this.imageUrl,
    required this.privacyText,
    required this.postPermissionText,
  });

  final String? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? imagePath;
  final String? country;
  final String? province;
  final String? district;
  final int? privacy;
  final int? postPermission;
  final DateTime? createdAt;
  final String? imageUrl;
  final String? privacyText;
  final String? postPermissionText;

  @override
  RelateableClub copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? imagePath,
    String? country,
    String? province,
    String? district,
    int? privacy,
    int? postPermission,
    DateTime? createdAt,
    String? imageUrl,
    String? privacyText,
    String? postPermissionText,
  }) {
    return RelateableClub(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      country: country ?? this.country,
      province: province ?? this.province,
      district: district ?? this.district,
      privacy: privacy ?? this.privacy,
      postPermission: postPermission ?? this.postPermission,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      privacyText: privacyText ?? this.privacyText,
      postPermissionText: postPermissionText ?? this.postPermissionText,
    );
  }

  factory RelateableClub.fromJson(Map<String, dynamic> json) {
    return RelateableClub(
      id: json["id"],
      name: json["name"],
      slug: json["slug"],
      description: json["description"],
      imagePath: json["image_path"],
      country: json["country"],
      province: json["province"],
      district: json["district"],
      privacy: json["privacy"],
      postPermission: json["post_permission"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      imageUrl: json["image_url"],
      privacyText: json["privacy_text"],
      postPermissionText: json["post_permission_text"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "description": description,
        "image_path": imagePath,
        "country": country,
        "province": province,
        "district": district,
        "privacy": privacy,
        "post_permission": postPermission,
        "created_at": createdAt?.toIso8601String(),
        "image_url": imageUrl,
        "privacy_text": privacyText,
        "post_permission_text": postPermissionText,
      };

  @override
  String toString() {
    return "$id, $name, $slug, $description, $imagePath, $country, $province, $district, $privacy, $postPermission, $createdAt, $imageUrl, $privacyText, $postPermissionText, ";
  }

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        description,
        imagePath,
        country,
        province,
        district,
        privacy,
        postPermission,
        createdAt,
        imageUrl,
        privacyText,
        postPermissionText,
      ];
}

class RelateableEvent extends Model {
  RelateableEvent({
    required this.id,
    required this.activity,
    required this.activityImageUrl,
    required this.title,
    required this.slug,
    required this.description,
    required this.imagePath,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.province,
    required this.district,
    required this.subdistrict,
    required this.village,
    required this.placeName,
    required this.postcode,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.quota,
    required this.isPublic,
    required this.isAutoPostToClub,
    required this.cancelledAt,
    required this.isOwner,
  });

  final String? id;
  final String? activity;
  final String? activityImageUrl;
  final String? title;
  final String? slug;
  final String? description;
  final dynamic imagePath;
  final dynamic imageUrl;
  final String? latitude;
  final String? longitude;
  final String? country;
  final String? province;
  final String? district;
  final String? subdistrict;
  final String? village;
  final String? placeName;
  final String? postcode;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final int? price;
  final int? quota;
  final int? isPublic;
  final int? isAutoPostToClub;
  final dynamic cancelledAt;
  final int? isOwner;

  @override
  RelateableEvent copyWith({
    String? id,
    String? activity,
    String? activityImageUrl,
    String? title,
    String? slug,
    String? description,
    dynamic? imagePath,
    dynamic? imageUrl,
    String? latitude,
    String? longitude,
    String? country,
    String? province,
    String? district,
    String? subdistrict,
    String? village,
    String? placeName,
    String? postcode,
    DateTime? date,
    String? startTime,
    String? endTime,
    int? price,
    int? quota,
    int? isPublic,
    int? isAutoPostToClub,
    dynamic? cancelledAt,
    int? isOwner,
  }) {
    return RelateableEvent(
      id: id ?? this.id,
      activity: activity ?? this.activity,
      activityImageUrl: activityImageUrl ?? this.activityImageUrl,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      country: country ?? this.country,
      province: province ?? this.province,
      district: district ?? this.district,
      subdistrict: subdistrict ?? this.subdistrict,
      village: village ?? this.village,
      placeName: placeName ?? this.placeName,
      postcode: postcode ?? this.postcode,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      price: price ?? this.price,
      quota: quota ?? this.quota,
      isPublic: isPublic ?? this.isPublic,
      isAutoPostToClub: isAutoPostToClub ?? this.isAutoPostToClub,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      isOwner: isOwner ?? this.isOwner,
    );
  }

  factory RelateableEvent.fromJson(Map<String, dynamic> json) {
    return RelateableEvent(
      id: json["id"],
      activity: json["activity"],
      activityImageUrl: json["activity_image_url"],
      title: json["title"],
      slug: json["slug"],
      description: json["description"],
      imagePath: json["image_path"],
      imageUrl: json["image_url"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      country: json["country"],
      province: json["province"],
      district: json["district"],
      subdistrict: json["subdistrict"],
      village: json["village"],
      placeName: json["place_name"],
      postcode: json["postcode"],
      date: DateTime.tryParse(json["date"] ?? ""),
      startTime: json["start_time"],
      endTime: json["end_time"],
      price: json["price"],
      quota: json["quota"],
      isPublic: json["is_public"],
      isAutoPostToClub: json["is_auto_post_to_club"],
      cancelledAt: json["cancelled_at"],
      isOwner: json["is_owner"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "activity": activity,
        "activity_image_url": activityImageUrl,
        "title": title,
        "slug": slug,
        "description": description,
        "image_path": imagePath,
        "image_url": imageUrl,
        "latitude": latitude,
        "longitude": longitude,
        "country": country,
        "province": province,
        "district": district,
        "subdistrict": subdistrict,
        "village": village,
        "place_name": placeName,
        "postcode": postcode,
        "date": date,
        "start_time": startTime,
        "end_time": endTime,
        "price": price,
        "quota": quota,
        "is_public": isPublic,
        "is_auto_post_to_club": isAutoPostToClub,
        "cancelled_at": cancelledAt,
        "is_owner": isOwner,
      };

  @override
  String toString() {
    return "$id, $activity, $activityImageUrl, $title, $slug, $description, $imagePath, $imageUrl, $latitude, $longitude, $country, $province, $district, $subdistrict, $village, $placeName, $postcode, $date, $startTime, $endTime, $price, $quota, $isPublic, $isAutoPostToClub, $cancelledAt, $isOwner, ";
  }

  @override
  List<Object?> get props => [
        id,
        activity,
        activityImageUrl,
        title,
        slug,
        description,
        imagePath,
        imageUrl,
        latitude,
        longitude,
        country,
        province,
        district,
        subdistrict,
        village,
        placeName,
        postcode,
        date,
        startTime,
        endTime,
        price,
        quota,
        isPublic,
        isAutoPostToClub,
        cancelledAt,
        isOwner,
      ];
}

class RelateableUser extends Model {
  RelateableUser({
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
  RelateableUser copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? imageUrl,
  }) {
    return RelateableUser(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory RelateableUser.fromJson(Map<String, dynamic> json) {
    return RelateableUser(
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
