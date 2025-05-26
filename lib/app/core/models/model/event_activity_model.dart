import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class EventActivityModel extends Model {
  EventActivityModel({
    required this.value,
    required this.label,
    required this.image,
  });

  final String? value;
  final String? label;
  final String? image;

  @override
  EventActivityModel copyWith({
    String? value,
    String? label,
    String? image,
  }) {
    return EventActivityModel(
      value: value ?? this.value,
      label: label ?? this.label,
      image: image ?? this.image,
    );
  }

  factory EventActivityModel.fromJson(Map<String, dynamic> json) {
    return EventActivityModel(
      value: json["value"],
      label: json["label"],
      image: json["image"],
    );
  }

  static List<EventActivityModel> defaultListEventActivity() {
    return [
      EventActivityModel(value: "Running", label: "Running", image: ""),
      EventActivityModel(value: "Badminton", label: "Badminton", image: ""),
    ];
  }

  @override
  Map<String, dynamic> toJson() => {
        "value": value,
        "label": label,
        "image": image,
      };

  @override
  List<Object?> get props => [
        value,
        label,
        image,
      ];
}
