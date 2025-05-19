import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class EventLocationModel extends Model {
  EventLocationModel({
    required this.value,
    required this.label,
  });

  final String? value;
  final String? label;

  @override
  EventLocationModel copyWith({
    String? value,
    String? label,
  }) {
    return EventLocationModel(
      value: value ?? this.value,
      label: label ?? this.label,
    );
  }

  factory EventLocationModel.fromJson(Map<String, dynamic> json) {
    return EventLocationModel(
      value: json["value"],
      label: json["label"],
    );
  }

  static List<EventLocationModel> defaultListEventActivity() {
    return [
      EventLocationModel(value: "Medan", label: "Medan"),
      EventLocationModel(value: "Jakarta", label: "Jakarta"),
    ];
  }

  @override
  Map<String, dynamic> toJson() => {
        "value": value,
        "label": label,
      };

  @override
  String toString() {
    return "$value, $label, ";
  }

  @override
  List<Object?> get props => [
        value,
        label,
      ];
}
