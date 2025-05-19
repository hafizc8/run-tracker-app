import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class ClubMiniModel extends Model {
  ClubMiniModel({
    required this.id,
    required this.name,
  });

  final String? id;
  final String? name;

  @override
  ClubMiniModel copyWith({
    String? id,
    String? name,
  }) {
    return ClubMiniModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory ClubMiniModel.fromJson(Map<String, dynamic> json) {
    return ClubMiniModel(
      id: json["id"],
      name: json["name"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  String toString() {
    return "$id, $name, ";
  }

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
