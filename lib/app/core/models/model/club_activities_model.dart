import 'package:equatable/equatable.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';

class ClubActivitiesModel extends Equatable {
    const ClubActivitiesModel({
        required this.clubId,
        required this.activityableId,
        required this.activityableType,
        required this.createdAt,
        required this.challange,
        required this.event,
    });

    final String? clubId;
    final String? activityableId;
    final String? activityableType;
    final DateTime? createdAt;
    final Challange? challange;
    final EventModel? event;

    ClubActivitiesModel copyWith({
        String? clubId,
        String? activityableId,
        String? activityableType,
        DateTime? createdAt,
        Challange? challange,
        EventModel? event,
    }) {
        return ClubActivitiesModel(
            clubId: clubId ?? this.clubId,
            activityableId: activityableId ?? this.activityableId,
            activityableType: activityableType ?? this.activityableType,
            createdAt: createdAt ?? this.createdAt,
            challange: challange ?? this.challange,
            event: event ?? this.event,
        );
    }

    factory ClubActivitiesModel.fromJson(Map<String, dynamic> json){ 
        return ClubActivitiesModel(
            clubId: json["club_id"],
            activityableId: json["activityable_id"],
            activityableType: json["activityable_type"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            challange: json["challange"] == null ? null : Challange.fromJson(json["challange"]),
            event: json["event"] == null ? null : EventModel.fromJson(json["event"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "club_id": clubId,
        "activityable_id": activityableId,
        "activityable_type": activityableType,
        "created_at": createdAt?.toIso8601String(),
        "challange": challange?.toJson(),
        "event": event?.toJson(),
    };

    @override
    List<Object?> get props => [
    clubId, activityableId, activityableType, createdAt, challange, event, ];
}

class Challange extends Equatable {
    Challange({
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
    final int? userProgress;
    final int? teamProgress;

    Challange copyWith({
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
        int? userProgress,
        int? teamProgress,
    }) {
        return Challange(
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
            userProgress: userProgress ?? this.userProgress,
            teamProgress: teamProgress ?? this.teamProgress,
        );
    }

    factory Challange.fromJson(Map<String, dynamic> json){ 
        return Challange(
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
            teams: json["teams"] == null ? [] : List<String>.from(json["teams"]!.map((x) => x)),
            userProgress: json["user_progress"],
            teamProgress: json["team_progress"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "type_text": typeText,
        "title": title,
        "mode": mode,
        "mode_text": modeText,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
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
        "user_progress": userProgress,
        "team_progress": teamProgress,
    };

    @override
    List<Object?> get props => [
    id, type, typeText, title, mode, modeText, startDate, endDate, clubId, target, teamSize, challangeUsersCount, cancelledAt, createdAt, isJoined, isOwner, isPendingJoin, teams, userProgress, teamProgress, ];
}