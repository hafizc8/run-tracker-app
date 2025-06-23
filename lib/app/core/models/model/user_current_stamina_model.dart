class CurrentUserStaminaModel {
  CurrentUserStaminaModel({
    required this.currentAmount,
    required this.updatedAt,
  });

  final int? currentAmount;
  final DateTime? updatedAt;

  factory CurrentUserStaminaModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserStaminaModel(
      currentAmount: json["current_amount"],
      updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "current_amount": currentAmount,
        "updated_at": updatedAt?.toIso8601String(),
      };
}