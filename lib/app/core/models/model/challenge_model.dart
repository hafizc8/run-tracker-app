import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/models/interface/model_interface.dart';
import 'package:zest_mobile/app/core/models/model/challenge_detail_model.dart';
import 'package:zest_mobile/app/core/models/model/home_page_data_model.dart';

class ChallengeModel extends Model<ChallengeModel> {
  ChallengeModel({
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
    dynamic? teamSize,
    int? challangeUsersCount,
    dynamic? cancelledAt,
    DateTime? createdAt,
    int? isJoined,
    int? isOwner,
    int? isPendingJoin,
    List<String>? teams,
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
      challangeUsersCount: challangeUsersCount ?? this.challangeUsersCount,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      createdAt: createdAt ?? this.createdAt,
      isJoined: isJoined ?? this.isJoined,
      isOwner: isOwner ?? this.isOwner,
      isPendingJoin: isPendingJoin ?? this.isPendingJoin,
      teams: teams ?? this.teams,
    );
  }

  factory ChallengeModel.fromDetail(ChallengeDetailModel detail) {
    return ChallengeModel(
      id: detail.id,
      type: detail.type,
      typeText: detail.typeText,
      title: detail.title,
      mode: detail.mode,
      modeText: detail.modeText,
      startDate: detail.startDate,
      endDate: detail.endDate,
      clubId: detail.clubId,
      target: detail.target,
      teamSize: detail.teamSize,
      challangeUsersCount: detail.challangeUsersCount,
      cancelledAt: detail.cancelledAt,
      createdAt: detail.createdAt,
      isJoined: detail.isJoined,
      isOwner: detail.isOwner,
      isPendingJoin: detail.isPendingJoin,
      teams: detail.teams,
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
      challangeUsersCount: json["challange_users_count"],
      cancelledAt: json["cancelled_at"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      isJoined: json["is_joined"],
      isOwner: json["is_owner"],
      isPendingJoin: json["is_pending_join"],
      teams: json["teams"] == null
          ? []
          : List<String>.from(json["teams"]!.map((x) => x)),
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
        "start_date": DateFormat('yyyy-MM-dd').format(startDate!),
        "end_date": DateFormat('yyyy-MM-dd').format(endDate!),
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
      };

  @override
  String toString() {
    return "$id, $type, $typeText, $title, $mode, $modeText, $startDate, $endDate, $clubId, $target, $teamSize, $challangeUsersCount, $cancelledAt, $createdAt, $isJoined, $isOwner, $isPendingJoin, $teams, ";
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
      ];
}
