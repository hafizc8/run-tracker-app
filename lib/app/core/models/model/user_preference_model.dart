class UserPreferenceModel {
  UserPreferenceModel({
    required this.unit,
    required this.unitText,
    required this.allowNotification,
    required this.allowEmailNotification,
    required this.dailyStepGoals,
  });

  final int? unit;
  final String? unitText;
  final bool? allowNotification;
  final bool? allowEmailNotification;
  final int? dailyStepGoals;

  factory UserPreferenceModel.fromJson(Map<String, dynamic> json) {
    return UserPreferenceModel(
      unit: json["unit"],
      unitText: json["unit_text"],
      allowNotification: json["allow_notification"] == 1,
      allowEmailNotification: json["allow_email_notification"] == 1,
      dailyStepGoals: json["daily_step_goals"],
    );
  }

  Map<String, dynamic> toJson() => {
        "unit": unit,
        "unit_text": unitText,
        "allow_notification": allowNotification,
        "allow_email_notification": allowEmailNotification,
        "daily_step_goals": dailyStepGoals,
      };
}