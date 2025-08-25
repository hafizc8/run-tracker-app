import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class BadgeModel extends Model {
  BadgeModel({
    required this.category,
    required this.categoryIcon,
    required this.badgeKey,
    required this.badgeName,
    required this.badgeIconUrl,
    required this.criteria,
    required this.notes,
    this.isLocked,
  });

  final String? category;
  final String? categoryIcon;
  final String? badgeKey;
  final String? badgeName;
  final String? badgeIconUrl;
  final String? criteria;
  final String? notes;
  final bool? isLocked;

  @override
  BadgeModel copyWith({
    String? category,
    String? categoryIcon,
    String? badgeKey,
    String? badgeName,
    String? badgeIconUrl,
    String? criteria,
    String? notes,
    bool? isLocked,
  }) {
    return BadgeModel(
      category: category ?? this.category,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      badgeKey: badgeKey ?? this.badgeKey,
      badgeName: badgeName ?? this.badgeName,
      badgeIconUrl: badgeIconUrl ?? this.badgeIconUrl,
      criteria: criteria ?? this.criteria,
      notes: notes ?? this.notes,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      category: json["category"],
      categoryIcon: json["category_icon"],
      badgeKey: json['badge_key'],
      badgeName: json["badge_name"],
      badgeIconUrl: json["badge_icon_url"],
      criteria: json["criteria"],
      notes: json["notes"],
      isLocked: true,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "category": category,
        "category_icon": categoryIcon,
        "badge_key": badgeKey,
        "badge_name": badgeName,
        "badge_icon_url": badgeIconUrl,
        "criteria": criteria,
        "notes": notes,
      };

  @override
  List<Object?> get props => [
        category,
        categoryIcon,
        badgeKey,
        badgeName,
        badgeIconUrl,
        criteria,
        notes,
        isLocked,
      ];
}
