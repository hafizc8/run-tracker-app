import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class SelectPlaceModel extends Model<SelectPlaceModel> {
  final double latitude;
  final double longitude;
  final String placeName;

  SelectPlaceModel(
      {this.latitude = 0, this.longitude = 0, this.placeName = ''});

  @override
  List<Object?> get props => [latitude, longitude, placeName];

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  SelectPlaceModel copyWith({
    double? latitude,
    double? longitude,
    String? placeName,
  }) {
    return SelectPlaceModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      placeName: placeName ?? this.placeName,
    );
  }

  factory SelectPlaceModel.fromJson(Map<String, dynamic> json) {
    return SelectPlaceModel(
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
      placeName: json['name'],
    );
  }
}
