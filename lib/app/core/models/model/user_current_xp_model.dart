class LevelDetailModel {
  LevelDetailModel({
    required this.level,
    required this.animal,
    required this.xpNeeded,
    required this.baseSweatEarned,
    required this.staminaIncreaseTotal,
    required this.staminaReplenishRate,
    required this.imageUrl,
  });

  final int? level;
  final String? animal;
  final int? xpNeeded;
  final double? baseSweatEarned;
  final int? staminaIncreaseTotal;
  final dynamic staminaReplenishRate;
  final String? imageUrl;

  factory LevelDetailModel.fromJson(Map<String, dynamic> json) {
    return LevelDetailModel(
      level: json["level"],
      animal: json["animal"],
      xpNeeded: json["xp_needed"],
      baseSweatEarned: (json["base_sweat_earned"] as num?)?.toDouble(),
      staminaIncreaseTotal: json["stamina_increase_total"],
      staminaReplenishRate: json["stamina_replenish_rate"],
      imageUrl: json["image_url"],
    );
  }

  Map<String, dynamic> toJson() => {
        "level": level,
        "animal": animal,
        "xp_needed": xpNeeded,
        "base_sweat_earned": baseSweatEarned,
        "stamina_increase_total": staminaIncreaseTotal,
        "stamina_replenish_rate": staminaReplenishRate,
        "image_url": imageUrl,
      };
}

class CurrentUserXpModel {
  CurrentUserXpModel({
    required this.currentLevel,
    required this.currentAmount,
    required this.updatedAt,
    required this.levelDetail,
  });

  final int? currentLevel;
  final int? currentAmount;
  final DateTime? updatedAt;
  final LevelDetailModel? levelDetail;

  factory CurrentUserXpModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserXpModel(
      currentLevel: json["current_level"],
      currentAmount: json["current_amount"],
      updatedAt: json["updated_at"] != null ? DateTime.tryParse(json["updated_at"]) : null,
      levelDetail: json["level_detail"] != null ? LevelDetailModel.fromJson(json["level_detail"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "current_level": currentLevel,
        "current_amount": currentAmount,
        "updated_at": updatedAt?.toIso8601String(),
        "level_detail": levelDetail?.toJson(),
      };
}