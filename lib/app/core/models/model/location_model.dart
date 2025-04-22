import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class LocationModel extends Model<LocationModel> {
  final String desc;
  final String placeId;

  LocationModel({this.desc = '', this.placeId = ''});

  @override
  // TODO: implement props
  List<Object?> get props => [desc, placeId];

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  LocationModel copyWith({
    String? desc,
    String? placeId,
  }) {
    return LocationModel(
        desc: desc ?? this.desc, placeId: placeId ?? this.placeId);
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(desc: json['description'], placeId: json['place_id']);
  }
}
