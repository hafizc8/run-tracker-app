import 'package:equatable/equatable.dart';
import 'package:zest_mobile/app/core/models/interface/model_interface.dart';

class ChallengeDetailModel extends Model {
  ChallengeDetailModel({
    required this.id,
    required this.type,
    required this.typeText,
    required this.title,
    required this.mode,
    required this.modeText,
    required this.startDate,
    required this.endDate,
    required this.clubId,
    required this.target,
    required this.teamSize,
    required this.challangeUsersCount,
    required this.cancelledAt,
    required this.createdAt,
    required this.isJoined,
    required this.isOwner,
    required this.isPendingJoin,
    required this.teams,
    required this.friendsTotal,
    required this.friendsNames,
    required this.leaderboardUsers,
    required this.leaderboardTeams,
    required this.totalUsersTeams,
    required this.userProgress,
    required this.teamProgress,
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
  final int? challangeUsersCount;
  final dynamic cancelledAt;
  final DateTime? createdAt;
  final int? isJoined;
  final int? isOwner;
  final int? isPendingJoin;
  final List<String> teams;
  final int? friendsTotal;
  final List<dynamic> friendsNames;
  final List<LeaderboardUser> leaderboardUsers;
  final List<LeaderboardTeam> leaderboardTeams;
  final List<TotalUsersTeams> totalUsersTeams;
  final int? userProgress;
  final int? teamProgress;

  @override
  ChallengeDetailModel copyWith({
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
    dynamic? teamSize,
    int? challangeUsersCount,
    dynamic? cancelledAt,
    DateTime? createdAt,
    int? isJoined,
    int? isOwner,
    int? isPendingJoin,
    List<String>? teams,
    int? friendsTotal,
    List<dynamic>? friendsNames,
    List<LeaderboardUser>? leaderboardUsers,
    List<LeaderboardTeam>? leaderboardTeams,
    List<TotalUsersTeams>? totalUsersTeams,
    int? userProgress,
    int? teamProgress,
  }) {
    return ChallengeDetailModel(
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
      challangeUsersCount: challangeUsersCount ?? this.challangeUsersCount,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
      isJoined: isJoined ?? this.isJoined,
      isOwner: isOwner ?? this.isOwner,
      isPendingJoin: isPendingJoin ?? this.isPendingJoin,
      teams: teams ?? this.teams,
      friendsTotal: friendsTotal ?? this.friendsTotal,
      friendsNames: friendsNames ?? this.friendsNames,
      leaderboardUsers: leaderboardUsers ?? this.leaderboardUsers,
      leaderboardTeams: leaderboardTeams ?? this.leaderboardTeams,
      totalUsersTeams: totalUsersTeams ?? this.totalUsersTeams,
      userProgress: userProgress ?? this.userProgress,
      teamProgress: teamProgress ?? this.teamProgress,
    );
  }

  factory ChallengeDetailModel.fromJson(Map<String, dynamic> json) {
    return ChallengeDetailModel(
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
      challangeUsersCount: json["challange_users_count"],
      cancelledAt: json["cancelled_at"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      isJoined: json["is_joined"],
      isOwner: json["is_owner"],
      isPendingJoin: json["is_pending_join"],
      teams: json["teams"] == null
          ? []
          : List<String>.from(json["teams"]!.map((x) => x)),
      friendsTotal: json["friends_total"],
      friendsNames: json["friends_names"] == null
          ? []
          : List<dynamic>.from(json["friends_names"]!.map((x) => x)),
      leaderboardUsers: json["leaderboard_users"] == null
          ? []
          : List<LeaderboardUser>.from(json["leaderboard_users"]!
              .map((x) => LeaderboardUser.fromJson(x))),
      leaderboardTeams: json["leaderboard_teams"] == null
          ? []
          : List<LeaderboardTeam>.from(json["leaderboard_teams"]!
              .map((x) => LeaderboardTeam.fromJson(x))),
      totalUsersTeams: json["total_user_teams"] == null
          ? []
          : List<TotalUsersTeams>.from(json["total_user_teams"]!
              .map((x) => TotalUsersTeams.fromJson(x))),
      userProgress: json["user_progress"],
      teamProgress: json["team_progress"],
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
        "start_date": startDate,
        "end_date": endDate,
        "club_id": clubId,
        "target": target,
        "team_size": teamSize,
        "challange_users_count": challangeUsersCount,
        "cancelled_at": cancelledAt,
        "created_at": createdAt?.toIso8601String(),
        "is_joined": isJoined,
        "is_owner": isOwner,
        "is_pending_join": isPendingJoin,
        "teams": teams.map((x) => x).toList(),
        "friends_total": friendsTotal,
        "friends_names": friendsNames.map((x) => x).toList(),
        "leaderboard_users": leaderboardUsers.map((x) => x.toJson()).toList(),
        "leaderboard_teams": leaderboardTeams.map((x) => x.toJson()).toList(),
        "user_progress": userProgress,
        "team_progress": teamProgress,
      };

  @override
  String toString() {
    return "$id, $type, $typeText, $title, $mode, $modeText, $startDate, $endDate, $clubId, $target, $teamSize, $challangeUsersCount, $cancelledAt, $createdAt, $isJoined, $isOwner, $isPendingJoin, $teams, $friendsTotal, $friendsNames, $leaderboardUsers, $leaderboardTeams, $userProgress, $teamProgress, ";
  }

  @override
  List<Object?> get props => [
        id,
        type,
        typeText,
        title,
        mode,
        modeText,
        startDate,
        endDate,
        clubId,
        target,
        teamSize,
        challangeUsersCount,
        cancelledAt,
        createdAt,
        isJoined,
        isOwner,
        isPendingJoin,
        teams,
        friendsTotal,
        friendsNames,
        leaderboardUsers,
        leaderboardTeams,
        userProgress,
        teamProgress,
      ];
}

class LeaderboardTeam extends Model {
  LeaderboardTeam({
    required this.rank,
    required this.point,
    required this.team,
  });

  final int? rank;
  final int? point;
  final String? team;

  @override
  LeaderboardTeam copyWith({
    int? rank,
    int? point,
    String? team,
  }) {
    return LeaderboardTeam(
      rank: rank ?? this.rank,
      point: point ?? this.point,
      team: team ?? this.team,
    );
  }

  factory LeaderboardTeam.fromJson(Map<String, dynamic> json) {
    return LeaderboardTeam(
      rank: json["rank"],
      point: json["point"],
      team: json["team"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "rank": rank,
        "point": point,
        "team": team,
      };

  @override
  String toString() {
    return "$rank, $point, $team, ";
  }

  @override
  List<Object?> get props => [
        rank,
        point,
        team,
      ];
}

class LeaderboardUser extends Model {
  LeaderboardUser({
    required this.rank,
    required this.point,
    required this.user,
  });

  final int? rank;
  final int? point;
  final User? user;

  @override
  LeaderboardUser copyWith({
    int? rank,
    int? point,
    User? user,
  }) {
    return LeaderboardUser(
      rank: rank ?? this.rank,
      point: point ?? this.point,
      user: user ?? this.user,
    );
  }

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      rank: json["rank"],
      point: json["point"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "rank": rank,
        "point": point,
        "user": user?.toJson(),
      };

  @override
  String toString() {
    return "$rank, $point, $user, ";
  }

  @override
  List<Object?> get props => [
        rank,
        point,
        user,
      ];
}

class TotalUsersTeams extends Model {
  TotalUsersTeams({
    required this.team,
    required this.total_users,
  });

  final String? team;
  final int? total_users;

  @override
  TotalUsersTeams copyWith({
    String? team,
    int? total_users,
  }) {
    return TotalUsersTeams(
      team: team ?? this.team,
      total_users: total_users ?? this.total_users,
    );
  }

  factory TotalUsersTeams.fromJson(Map<String, dynamic> json) {
    return TotalUsersTeams(
      team: json["team"],
      total_users: json["total_users"],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "team": team,
        "total_users": total_users,
      };

  @override
  String toString() {
    return "$team, $total_users, ";
  }

  @override
  List<Object?> get props => [
        team,
        total_users,
      ];
}

class User extends Model {
  User({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.imageUrl,
  });

  final String? id;
  final String? name;
  final String? imagePath;
  final String? imageUrl;

  @override
  User copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? imageUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
  String toString() {
    return "$id, $name, $imagePath, $imageUrl, ";
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imagePath,
        imageUrl,
      ];
}
