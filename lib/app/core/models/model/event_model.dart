import 'package:equatable/equatable.dart';
import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class EventModel extends Equatable {
  EventModel({
    required this.id,
    required this.activity,
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
    required this.postcode,
    required this.datetime,
    required this.price,
    required this.quota,
    required this.isPublic,
    required this.isAutoPostToClub,
    required this.cancelledAt,
    required this.isOwner,
    required this.isPendingJoin,
    required this.isJoined,
    required this.user,
    required this.userOnEvents,
    required this.userOnEventsCount,
  });

  final String? id;
  final String? activity;
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
  final dynamic postcode;
  final DateTime? datetime;
  final int? price;
  final int? quota;
  final int? isPublic;
  final int? isAutoPostToClub;
  final DateTime? cancelledAt;
  final int? isOwner;
  final int? isPendingJoin;
  final int? isJoined;
  final User? user;
  final List<EventUserModel>? userOnEvents;
  final int? userOnEventsCount;

  EventModel copyWith({
    String? id,
    String? activity,
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
    dynamic? postcode,
    DateTime? datetime,
    int? price,
    int? quota,
    int? isPublic,
    int? isAutoPostToClub,
    DateTime? cancelledAt,
    int? isOwner,
    int? isPendingJoin,
    int? isJoined,
    User? user,
    List<EventUserModel>? userOnEvents,
    int? userOnEventsCount,
  }) {
    return EventModel(
      id: id ?? this.id,
      activity: activity ?? this.activity,
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
      postcode: postcode ?? this.postcode,
      datetime: datetime ?? this.datetime,
      price: price ?? this.price,
      quota: quota ?? this.quota,
      isPublic: isPublic ?? this.isPublic,
      isAutoPostToClub: isAutoPostToClub ?? this.isAutoPostToClub,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      isOwner: isOwner ?? this.isOwner,
      isPendingJoin: isPendingJoin ?? this.isPendingJoin,
      isJoined: isJoined ?? this.isJoined,
      user: user ?? this.user,
      userOnEvents: userOnEvents ?? this.userOnEvents,
      userOnEventsCount: userOnEventsCount ?? this.userOnEventsCount,
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["id"],
      activity: json["activity"],
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
      postcode: json["postcode"],
      datetime: DateTime.tryParse(json["date"] ?? ""),
      price: json["price"],
      quota: json["quota"],
      isPublic: json["is_public"],
      isAutoPostToClub: json["is_auto_post_to_club"],
      cancelledAt: DateTime.tryParse(json["cancelled_at"] ?? ""),
      isOwner: json["is_owner"],
      isPendingJoin: json["is_pending_join"],
      isJoined: json["is_joined"],
      user: json["user"] == null
          ? null
          : User.fromJson(
              json["user"],
            ),
      userOnEvents: json["event_users"] == null
          ? null
          : List<EventUserModel>.from(
              json["event_users"].map((x) => EventUserModel.fromJson(x))),
      userOnEventsCount: json["event_users_count"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "activity": activity,
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
        "postcode": postcode,
        "datetime": datetime?.toIso8601String(),
        "price": price,
        "quota": quota,
        "is_public": isPublic,
        "is_auto_post_to_club": isAutoPostToClub,
        "cancelled_at": cancelledAt?.toIso8601String(),
        "is_owner": isOwner,
        "is_pending_join": isPendingJoin,
        "is_joined": isJoined,
        "user": user?.toJson(),
        "event_users": userOnEvents == null
            ? null
            : List<dynamic>.from(userOnEvents!.map((x) => x.toJson())),
        "event_users_count": userOnEventsCount
      };

  String get address =>
      "$village, $subdistrict, $district, $province, $country";

  @override
  List<Object?> get props => [
        id,
        activity,
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
        postcode,
        datetime,
        price,
        quota,
        isPublic,
        isAutoPostToClub,
        cancelledAt,
        isOwner,
        isPendingJoin,
        isJoined,
        user,
        userOnEvents,
        userOnEventsCount,
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

class EventUserModel extends Equatable {
  EventUserModel({
    required this.id,
    required this.status,
    required this.statusText,
    required this.user,
  });

  final String? id;
  final int? status;
  final String? statusText;
  final User? user;

  EventUserModel copyWith({
    String? id,
    int? status,
    String? statusText,
    User? user,
  }) {
    return EventUserModel(
      id: id ?? this.id,
      status: status ?? this.status,
      statusText: statusText ?? this.statusText,
      user: user ?? this.user,
    );
  }

  factory EventUserModel.fromJson(Map<String, dynamic> json) {
    return EventUserModel(
      id: json["id"],
      status: json["status"],
      statusText: json["status_text"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "status_text": statusText,
        "user": user?.toJson(),
      };

  @override
  String toString() {
    return "$id, $status, $statusText, $user, ";
  }

  @override
  List<Object?> get props => [
        id,
        status,
        statusText,
        user,
      ];
}
