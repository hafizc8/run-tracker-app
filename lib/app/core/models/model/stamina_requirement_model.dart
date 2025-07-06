import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class StaminaRequirementModel extends Model<StaminaRequirementModel> {
  StaminaRequirementModel({
    this.staminaUsedMin,
    this.staminaUsedMax,
    this.sessionMinuteMultiplier,
    this.sessionMinuteMin,
    this.sessionMinuteMax,
    this.multiplier,
  });

  final int? staminaUsedMin;
  final int? staminaUsedMax;
  final int? sessionMinuteMultiplier;
  final int? sessionMinuteMin;
  final int? sessionMinuteMax;
  final int? multiplier;

  @override
  StaminaRequirementModel copyWith({
    int? staminaUsedMin,
    int? staminaUsedMax,
    int? sessionMinuteMultiplier,
    int? sessionMinuteMin,
    int? sessionMinuteMax,
    int? multiplier,
  }) {
    return StaminaRequirementModel(
      staminaUsedMin: staminaUsedMin ?? this.staminaUsedMin,
      staminaUsedMax: staminaUsedMax ?? this.staminaUsedMax,
      sessionMinuteMultiplier:
          sessionMinuteMultiplier ?? this.sessionMinuteMultiplier,
      sessionMinuteMin: sessionMinuteMin ?? this.sessionMinuteMin,
      sessionMinuteMax: sessionMinuteMax ?? this.sessionMinuteMax,
      multiplier: multiplier ?? this.multiplier,
    );
  }

  factory StaminaRequirementModel.fromJson(Map<String, dynamic> json) {
    return StaminaRequirementModel(
      staminaUsedMin: json["stamina_used_min"],
      staminaUsedMax: json["stamina_used_max"],
      sessionMinuteMultiplier: json["session_minute_multiplier"],
      sessionMinuteMin: json["session_minute_min"],
      sessionMinuteMax: json["session_minute_max"],
      multiplier: json["multiplier"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "stamina_used_min": staminaUsedMin,
        "stamina_used_max": staminaUsedMax,
        "session_minute_multiplier": sessionMinuteMultiplier,
        "session_minute_min": sessionMinuteMin,
        "session_minute_max": sessionMinuteMax,
        "multiplier": multiplier,
      };

  @override
  List<Object?> get props => [
        staminaUsedMin,
        staminaUsedMax,
        sessionMinuteMultiplier,
        sessionMinuteMin,
        sessionMinuteMax,
        multiplier,
      ];
}
