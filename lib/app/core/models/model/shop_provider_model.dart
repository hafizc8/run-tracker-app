import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class ShopProviderModel extends Model {
  ShopProviderModel({
    required this.id,
    required this.name,
    required this.link,
    required this.imageUrl,
  });

  final String? id;
  final String? name;
  final String? link;
  final String? imageUrl;

  @override
  ShopProviderModel copyWith({
    String? id,
    String? name,
    String? link,
    String? imageUrl,
  }) {
    return ShopProviderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      link: link ?? this.link,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory ShopProviderModel.fromJson(Map<String, dynamic> json) {
    return ShopProviderModel(
      id: json["id"],
      name: json["name"],
      link: json["link"],
      imageUrl: json["image_url"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "link": link,
        "image_url": imageUrl,
      };

  @override
  String toString() {
    return "$id, $name, $link, $imageUrl, ";
  }

  @override
  List<Object?> get props => [
        id,
        name,
        link,
        imageUrl,
      ];
}
