import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class EventActivityModel extends Model {
  EventActivityModel({
    required this.value,
    required this.label,
  });

  final String? value;
  final String? label;

  @override
  EventActivityModel copyWith({
    String? value,
    String? label,
  }) {
    return EventActivityModel(
      value: value ?? this.value,
      label: label ?? this.label,
    );
  }

  factory EventActivityModel.fromJson(Map<String, dynamic> json) {
    return EventActivityModel(
      value: json["value"],
      label: json["label"],
    );
  }

  static List<EventActivityModel> defaultListEventActivity() {
    return [
      EventActivityModel(value: "Running", label: "Running"),
      EventActivityModel(value: "Badminton", label: "Badminton"),
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
