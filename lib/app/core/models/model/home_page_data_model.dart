import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/models/interface/model_interface.dart';
import 'package:zest_mobile/app/core/models/model/leaderboard_user_model.dart';

// =========================================================================
// MODEL UTAMA
// =========================================================================

class HomePageDataModel extends Model<HomePageDataModel> {
  HomePageDataModel({
    this.recordDailyStreakCount,
    this.recordDaily,
    this.leaderboards,
    this.challenge,
    this.unreadNotificationCount,
    this.unreadChatCount,
  });

  final int? recordDailyStreakCount;
  final int? unreadNotificationCount;
  final int? unreadChatCount;
  final RecordDailyModel? recordDaily;
  final List<LeaderboardUserModel>? leaderboards;
  final ChallengeModel? challenge;

  @override
  HomePageDataModel copyWith({
    int? recordDailyStreakCount,
    RecordDailyModel? recordDaily,
    List<LeaderboardUserModel>? leaderboards,
    ChallengeModel? challenge,
    int? unreadNotificationCount,
    int? unreadChatCount,
  }) {
    return HomePageDataModel(
      recordDailyStreakCount: recordDailyStreakCount ?? this.recordDailyStreakCount,
      recordDaily: recordDaily ?? this.recordDaily,
      leaderboards: leaderboards ?? this.leaderboards,
      challenge: challenge ?? this.challenge,
      unreadNotificationCount: unreadNotificationCount ?? this.unreadNotificationCount,
      unreadChatCount: unreadChatCount ?? this.unreadChatCount,
    );
  }

  factory HomePageDataModel.fromJson(Map<String, dynamic> json) {
    return HomePageDataModel(
      recordDailyStreakCount: json["record_daily_streak_count"],
      recordDaily: json["record_daily"] == null
          ? null
          : RecordDailyModel.fromJson(json["record_daily"]),
      leaderboards: json["leaderboards"] == null
          ? []
          : List<LeaderboardUserModel>.from(json["leaderboards"]!.map((x) => LeaderboardUserModel.fromJson(x))),
      challenge: json["challange"] == null ? null : ChallengeModel.fromJson(json["challange"]),
      unreadNotificationCount: json["unread_notification_count"] ?? 0,
      unreadChatCount: json["unread_chat_count"] ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "record_daily_streak_count": recordDailyStreakCount,
        "record_daily": recordDaily,
        "leaderboards": leaderboards?.map((x) => x.toJson()).toList(),
        "challange": challenge?.toJson(),
        "unread_notification_count": unreadNotificationCount,
        "unread_chat_count": unreadChatCount,
      };

  @override
  List<Object?> get props => [
        recordDailyStreakCount,
        recordDaily,
        leaderboards,
        challenge,
        unreadNotificationCount,
        unreadChatCount,
      ];
}

class RecordDailyModel extends Model<RecordDailyModel> {
  RecordDailyModel({
    this.id,
    this.userId,
    this.date,
    this.stepGoal,
    this.step,
    this.calorie,
    this.time,
    this.xpPerStep,
    this.xpDailyBonus,
    this.xpRecordActivity,
    this.xpSpecialEvent,
    this.updatedAt,
  });

  final String? id;
  final String? userId;
  final DateTime? date;
  final int? stepGoal;
  final int? step;
  final int? calorie;
  final int? time;
  final int? xpPerStep;
  final int? xpDailyBonus;
  final int? xpRecordActivity;
  final int? xpSpecialEvent;
  final DateTime? updatedAt;

  @override
  RecordDailyModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? stepGoal,
    int? step,
    int? calorie,
    int? time,
    int? xpPerStep,
    int? xpDailyBonus,
    int? xpRecordActivity,
    int? xpSpecialEvent,
    DateTime? updatedAt,
  }) {
    return RecordDailyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      stepGoal: stepGoal ?? this.stepGoal,
      step: step ?? this.step,
      calorie: calorie ?? this.calorie,
      time: time ?? this.time,
      xpPerStep: xpPerStep ?? this.xpPerStep,
      xpDailyBonus: xpDailyBonus ?? this.xpDailyBonus,
      xpRecordActivity: xpRecordActivity ?? this.xpRecordActivity,
      xpSpecialEvent: xpSpecialEvent ?? this.xpSpecialEvent,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory RecordDailyModel.fromJson(Map<String, dynamic> json) {
    return RecordDailyModel(
      id: json["id"],
      userId: json["user_id"],
      date: DateTime.tryParse(json["date"] ?? ""),
      stepGoal: json["step_goal"],
      step: json["step"],
      calorie: json["calorie"],
      time: json["time"],
      xpPerStep: json["xp_per_step"],
      xpDailyBonus: json["xp_daily_bonus"],
      xpRecordActivity: json["xp_record_activity"],
      xpSpecialEvent: json["xp_special_event"],
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "date": date?.toIso8601String(),
        "step_goal": stepGoal,
        "step": step,
        "calorie": calorie,
        "time": time,
        "xp_per_step": xpPerStep,
        "xp_daily_bonus": xpDailyBonus,
        "xp_record_activity": xpRecordActivity,
        "xp_special_event": xpSpecialEvent,
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, userId, date, step, stepGoal, updatedAt];
}

// =========================================================================
// SUB-MODEL UNTUK CHALLENGE
// =========================================================================

class ChallengeModel extends Model<ChallengeModel> {
  ChallengeModel({
    this.id,
    this.type,
    this.typeText,
    this.title,
    this.mode,
    this.modeText,
    this.startDate,
    this.endDate,
    this.clubId,
    this.target,
    this.teamSize,
    this.challengeUsersCount,
    this.cancelledAt,
    this.createdAt,
    this.isJoined,
    this.isOwner,
    this.isPendingJoin,
    this.teams,
    this.userProgress,
    this.teamProgress,
    this.challengeUsers,
  });

  final String? id;
  final int? type;
  final String? typeText;
  final String? title;
  final int? mode;
  final String? modeText;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? clubId;
  final int? target;
  final dynamic teamSize;
  final int? challengeUsersCount;
  final dynamic cancelledAt;
  final DateTime? createdAt;
  final dynamic isJoined;
  final dynamic isOwner;
  final dynamic isPendingJoin;
  final List<String>? teams;
  final int? userProgress;
  final int? teamProgress;
  final List<ChallengeUserModel>? challengeUsers;

  @override
  ChallengeModel copyWith({
    String? id,
    int? type,
    String? typeText,
    String? title,
    int? mode,
    String? modeText,
    DateTime? startDate,
    DateTime? endDate,
    String? clubId,
    int? target,
    dynamic teamSize,
    int? challengeUsersCount,
    dynamic cancelledAt,
    DateTime? createdAt,
    dynamic isJoined,
    dynamic isOwner,
    dynamic isPendingJoin,
    List<String>? teams,
    int? userProgress,
    int? teamProgress,
    List<ChallengeUserModel>? challengeUsers,
  }) {
    return ChallengeModel(
      id: id ?? this.id,
      type: type ?? this.type,
      typeText: typeText ?? this.typeText,
      title: title ?? this.title,
      mode: mode ?? this.mode,
      modeText: modeText ?? this.modeText,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      clubId: clubId ?? this.clubId,
      target: target ?? this.target,
      teamSize: teamSize ?? this.teamSize,
      challengeUsersCount: challengeUsersCount ?? this.challengeUsersCount,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
      isJoined: isJoined ?? this.isJoined,
      isOwner: isOwner ?? this.isOwner,
      isPendingJoin: isPendingJoin ?? this.isPendingJoin,
      teams: teams ?? this.teams,
      userProgress: userProgress ?? this.userProgress,
      teamProgress: teamProgress ?? this.teamProgress,
      challengeUsers: challengeUsers ?? this.challengeUsers,
    );
  }

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json["id"],
      type: json["type"],
      typeText: json["type_text"],
      title: json["title"],
      mode: json["mode"],
      modeText: json["mode_text"],
      startDate: DateTime.tryParse(json["start_date"] ?? ""),
      endDate: DateTime.tryParse(json["end_date"] ?? ""),
      clubId: json["club_id"],
      target: json["target"],
      teamSize: json["team_size"],
      challengeUsersCount: json["challange_users_count"],
      cancelledAt: json["cancelled_at"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      isJoined: json["is_joined"],
      isOwner: json["is_owner"],
      isPendingJoin: json["is_pending_join"],
      teams: json["teams"] == null ? [] : List<String>.from(json["teams"]!.map((x) => x)),
      userProgress: json["user_progress"],
      teamProgress: json["team_progress"],
      challengeUsers: json["challange_users"] == null ? [] : List<ChallengeUserModel>.from(json["challange_users"]!.map((x) => ChallengeUserModel.fromJson(x))),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "type_text": typeText,
        "title": title,
        "mode": mode,
        "mode_text": modeText,
        "start_date": startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : null,
        "end_date": endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null,
        "club_id": clubId,
        "target": target,
        "team_size": teamSize,
        "challange_users_count": challengeUsersCount,
        "created_at": createdAt?.toIso8601String(),
        "teams": teams,
        "user_progress": userProgress,
        "team_progress": teamProgress,
        "challange_users": challengeUsers?.map((x) => x.toJson()).toList(),
      };
      
  @override
  List<Object?> get props => [id, title, startDate, endDate, challengeUsers];
}

class ChallengeUserModel extends Model<ChallengeUserModel> {
  ChallengeUserModel({
    this.id,
    this.team,
    this.isPendingJoin,
    this.user,
  });

  final String? id;
  final String? team;
  final int? isPendingJoin;
  final UserSummaryModel? user;

  @override
  ChallengeUserModel copyWith({
    String? id,
    String? team,
    int? isPendingJoin,
    UserSummaryModel? user,
  }) {
    return ChallengeUserModel(
      id: id ?? this.id,
      team: team ?? this.team,
      isPendingJoin: isPendingJoin ?? this.isPendingJoin,
      user: user ?? this.user,
    );
  }

  factory ChallengeUserModel.fromJson(Map<String, dynamic> json) {
    return ChallengeUserModel(
      id: json["id"],
      team: json["team"],
      isPendingJoin: json["is_pending_join"],
      user: json["user"] == null ? null : UserSummaryModel.fromJson(json["user"]),
    );
  }
  
  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "team": team,
        "is_pending_join": isPendingJoin,
        "user": user?.toJson(),
      };

  @override
  List<Object?> get props => [id, team, isPendingJoin, user];
}

class UserSummaryModel extends Model<UserSummaryModel> {
  UserSummaryModel({
    this.id,
    this.name,
    this.imagePath,
    this.imageUrl,
  });

  final String? id;
  final String? name;
  final String? imagePath;
  final String? imageUrl;

  @override
  UserSummaryModel copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? imageUrl,
  }) {
    return UserSummaryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory UserSummaryModel.fromJson(Map<String, dynamic> json) {
    return UserSummaryModel(
      id: json["id"],
      name: json["name"],
      imagePath: json["image_path"],
      imageUrl: json["image_url"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_path": imagePath,
        "image_url": imageUrl,
      };
      
  @override
  List<Object?> get props => [id, name, imageUrl];
}
