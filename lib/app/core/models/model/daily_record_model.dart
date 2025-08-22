import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class DailyRecordModel extends Model<DailyRecordModel> {
  DailyRecordModel({
    this.id,
    this.userId,
    this.date,
    this.stepGoal,
    this.step,
    this.calorie,
    this.time,
    this.streak,
    this.xpPerStep,
    this.xpDailyBonus,
    this.xpRecordActivity,
    this.xpSpecialEvent,
    this.updatedAt,
    this.lastTimestamp,
  });

  final String? id;
  final String? userId;
  final DateTime? date;
  final int? stepGoal;
  final int? step;
  final int? calorie;
  final int? time;
  final int? streak;
  final int? xpPerStep;
  final int? xpDailyBonus;
  final int? xpRecordActivity;
  final int? xpSpecialEvent;
  final DateTime? updatedAt;
  final DateTime? lastTimestamp;

  @override
  DailyRecordModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? stepGoal,
    int? step,
    int? calorie,
    int? time,
    int? streak,
    int? xpPerStep,
    int? xpDailyBonus,
    int? xpRecordActivity,
    int? xpSpecialEvent,
    DateTime? updatedAt,
    DateTime? lastTimestamp,
  }) {
    return DailyRecordModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      stepGoal: stepGoal ?? this.stepGoal,
      step: step ?? this.step,
      calorie: calorie ?? this.calorie,
      time: time ?? this.time,
      streak: streak ?? this.streak,
      xpPerStep: xpPerStep ?? this.xpPerStep,
      xpDailyBonus: xpDailyBonus ?? this.xpDailyBonus,
      xpRecordActivity: xpRecordActivity ?? this.xpRecordActivity,
      xpSpecialEvent: xpSpecialEvent ?? this.xpSpecialEvent,
      updatedAt: updatedAt ?? this.updatedAt,
      lastTimestamp: lastTimestamp ?? this.lastTimestamp,
    );
  }

  factory DailyRecordModel.fromJson(Map<String, dynamic> json) {
    return DailyRecordModel(
      id: json["id"],
      userId: json["user_id"],
      date: DateTime.tryParse(json["date"] ?? ""),
      stepGoal: json["step_goal"],
      step: json["step"],
      calorie: json["calorie"],
      time: json["time"],
      streak: json["streak"],
      xpPerStep: json["xp_per_step"],
      xpDailyBonus: json["xp_daily_bonus"],
      xpRecordActivity: json["xp_record_activity"],
      xpSpecialEvent: json["xp_special_event"],
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      lastTimestamp: DateTime.tryParse(json["last_timestamp"] ?? ""),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "date": date != null ? DateFormat('yyyy-MM-dd').format(date!) : null,
        "step_goal": stepGoal,
        "step": step,
        "calorie": calorie,
        "time": time,
        "streak": streak,
        "xp_per_step": xpPerStep,
        "xp_daily_bonus": xpDailyBonus,
        "xp_record_activity": xpRecordActivity,
        "xp_special_event": xpSpecialEvent,
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        stepGoal,
        step,
        calorie,
        time,
        streak,
        xpPerStep,
        xpDailyBonus,
        xpRecordActivity,
        xpSpecialEvent,
        updatedAt,
        lastTimestamp
      ];
}
