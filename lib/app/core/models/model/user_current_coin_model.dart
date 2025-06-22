class CurrentUserCoinModel {
  CurrentUserCoinModel({
    required this.currentAmount,
    required this.updatedAt,
  });

  final int? currentAmount;
  final DateTime? updatedAt;

  factory CurrentUserCoinModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserCoinModel(
      currentAmount: json["current_amount"],
      updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "current_amount": currentAmount,
        "updated_at": updatedAt?.toIso8601String(),
      };
}