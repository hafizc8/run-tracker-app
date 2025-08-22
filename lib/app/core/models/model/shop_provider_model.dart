import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class ShopProviderModel extends Model {
  ShopProviderModel({
    required this.sliders,
    required this.links,
  });

  final List<String> sliders;
  final List<Link> links;

  @override
  ShopProviderModel copyWith({
    List<String>? sliders,
    List<Link>? links,
  }) {
    return ShopProviderModel(
      sliders: sliders ?? this.sliders,
      links: links ?? this.links,
    );
  }

  factory ShopProviderModel.fromJson(Map<String, dynamic> json) {
    return ShopProviderModel(
      sliders: json["sliders"] == null
          ? []
          : List<String>.from(json["sliders"]!.map((x) => x)),
      links: json["links"] == null
          ? []
          : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "sliders": sliders.map((x) => x).toList(),
        "links": links.map((x) => x?.toJson()).toList(),
      };

  @override
  String toString() {
    return "$sliders, $links, ";
  }

  @override
  List<Object?> get props => [
        sliders,
        links,
      ];
}

class Link extends Model {
  Link({
    required this.title,
    required this.imageUrl,
    required this.link,
  });

  final String? title;
  final String? imageUrl;
  final String? link;

  @override
  Link copyWith({
    String? title,
    String? imageUrl,
    String? link,
  }) {
    return Link(
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      link: link ?? this.link,
    );
  }

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      title: json["title"],
      imageUrl: json["image_url"],
      link: json["link"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "title": title,
        "image_url": imageUrl,
        "link": link,
      };

  @override
  String toString() {
    return "$title, $imageUrl, $link, ";
  }

  @override
  List<Object?> get props => [
        title,
        imageUrl,
        link,
      ];
}
