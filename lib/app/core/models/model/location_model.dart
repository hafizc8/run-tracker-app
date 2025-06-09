import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class LocationModel extends Model<LocationModel> {
  final String desc;
  final String placeId;
  final String placeName;

  LocationModel({this.desc = '', this.placeId = '', this.placeName = ''});

  @override
  List<Object?> get props => [desc, placeId, placeName];

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  LocationModel copyWith({
    String? desc,
    String? placeId,
    String? placeName,
  }) {
    return LocationModel(
      desc: desc ?? this.desc,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
    );
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      desc: json['description'],
      placeId: json['place_id'],
      placeName: json['structured_formatting']['main_text'],
    );
  }
}
