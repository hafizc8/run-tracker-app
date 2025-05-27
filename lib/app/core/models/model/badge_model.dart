import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class BadgeModel extends Model {
  BadgeModel({
    required this.category,
    required this.categoryIcon,
    required this.badgeName,
    required this.badgeIconUrl,
    required this.criteria,
    required this.notes,
  });

  final String? category;
  final String? categoryIcon;
  final String? badgeName;
  final String? badgeIconUrl;
  final String? criteria;
  final String? notes;

  @override
  BadgeModel copyWith({
    String? category,
    String? categoryIcon,
    String? badgeName,
    String? badgeIconUrl,
    String? criteria,
    String? notes,
  }) {
    return BadgeModel(
      category: category ?? this.category,
      categoryIcon: categoryIcon ?? this.categoryIcon,
      badgeName: badgeName ?? this.badgeName,
      badgeIconUrl: badgeIconUrl ?? this.badgeIconUrl,
      criteria: criteria ?? this.criteria,
      notes: notes ?? this.notes,
    );
  }

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      category: json["category"],
      categoryIcon: json["category_icon"],
      badgeName: json["badge_name"],
      badgeIconUrl: json["badge_icon_url"],
      criteria: json["criteria"],
      notes: json["notes"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "category": category,
        "category_icon": categoryIcon,
        "badge_name": badgeName,
        "badge_icon_url": badgeIconUrl,
        "criteria": criteria,
        "notes": notes,
      };

  @override
  List<Object?> get props => [
        category,
        categoryIcon,
        badgeName,
        badgeIconUrl,
        criteria,
        notes,
      ];
}
