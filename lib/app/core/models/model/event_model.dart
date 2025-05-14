import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class EventModel extends Model {
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
  });

  final String? id;
  final String? activity;
  final String? title;
  final String? slug;
  final String? description;
  final String? imagePath;
  final String? imageUrl;
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
  final dynamic cancelledAt;

  @override
  EventModel copyWith({
    String? id,
    String? activity,
    String? title,
    String? slug,
    String? description,
    String? imagePath,
    String? imageUrl,
    String? latitude,
    String? longitude,
    String? country,
    String? province,
    String? district,
    String? subdistrict,
    String? village,
    String? postcode,
    DateTime? datetime,
    int? price,
    int? quota,
    int? isPublic,
    int? isAutoPostToClub,
    String? cancelledAt,
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
      datetime: DateTime.tryParse(json["datetime"] ?? ""),
      price: json["price"],
      quota: json["quota"],
      isPublic: json["is_public"],
      isAutoPostToClub: json["is_auto_post_to_club"],
      cancelledAt: json["cancelled_at"],
    );
  }
  String get address =>
      "$village, $subdistrict, $district, $province, $country";
  @override
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
        "cancelled_at": cancelledAt,
      };

  @override
  String toString() {
    return "$id, $activity, $title, $slug, $description, $imagePath, $imageUrl, $latitude, $longitude, $country, $province, $district, $subdistrict, $village, $postcode, $datetime, $price, $quota, $isPublic, $isAutoPostToClub, $cancelledAt, ";
  }

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
      ];
}
