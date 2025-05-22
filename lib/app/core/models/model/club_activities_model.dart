import 'package:equatable/equatable.dart';

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
    final Event? event;

    ClubActivitiesModel copyWith({
        String? clubId,
        String? activityableId,
        String? activityableType,
        DateTime? createdAt,
        Challange? challange,
        Event? event,
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
            event: json["event"] == null ? null : Event.fromJson(json["event"]),
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

class Event extends Equatable {
    Event({
        required this.id,
        required this.activity,
        required this.title,
        required this.slug,
        required this.description,
        required this.imagePath,
        required this.imageUrl,
        required this.latitude,
        required this.longitude,
        required this.country,
        required this.province,
        required this.district,
        required this.subdistrict,
        required this.village,
        required this.postcode,
        required this.datetime,
        required this.price,
        required this.quota,
        required this.isPublic,
        required this.isAutoPostToClub,
        required this.cancelledAt,
        required this.isOwner,
        required this.isJoined,
        required this.user,
        required this.eventUsers,
        required this.eventUsersCount,
    });

    final String? id;
    final String? activity;
    final String? title;
    final String? slug;
    final String? description;
    final dynamic imagePath;
    final dynamic imageUrl;
    final String? latitude;
    final String? longitude;
    final String? country;
    final String? province;
    final String? district;
    final String? subdistrict;
    final String? village;
    final String? postcode;
    final DateTime? datetime;
    final int? price;
    final int? quota;
    final int? isPublic;
    final int? isAutoPostToClub;
    final dynamic cancelledAt;
    final int? isOwner;
    final int? isJoined;
    final User? user;
    final List<EventUser> eventUsers;
    final int? eventUsersCount;

    Event copyWith({
        String? id,
        String? activity,
        String? title,
        String? slug,
        String? description,
        dynamic? imagePath,
        dynamic? imageUrl,
        String? latitude,
        String? longitude,
        String? country,
        String? province,
        String? district,
        String? subdistrict,
        String? village,
        String? postcode,
        DateTime? datetime,
        int? price,
        int? quota,
        int? isPublic,
        int? isAutoPostToClub,
        dynamic? cancelledAt,
        int? isOwner,
        int? isJoined,
        User? user,
        List<EventUser>? eventUsers,
        int? eventUsersCount,
    }) {
        return Event(
            id: id ?? this.id,
            activity: activity ?? this.activity,
            title: title ?? this.title,
            slug: slug ?? this.slug,
            description: description ?? this.description,
            imagePath: imagePath ?? this.imagePath,
            imageUrl: imageUrl ?? this.imageUrl,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
            country: country ?? this.country,
            province: province ?? this.province,
            district: district ?? this.district,
            subdistrict: subdistrict ?? this.subdistrict,
            village: village ?? this.village,
            postcode: postcode ?? this.postcode,
            datetime: datetime ?? this.datetime,
            price: price ?? this.price,
            quota: quota ?? this.quota,
            isPublic: isPublic ?? this.isPublic,
            isAutoPostToClub: isAutoPostToClub ?? this.isAutoPostToClub,
            cancelledAt: cancelledAt ?? this.cancelledAt,
            isOwner: isOwner ?? this.isOwner,
            isJoined: isJoined ?? this.isJoined,
            user: user ?? this.user,
            eventUsers: eventUsers ?? this.eventUsers,
            eventUsersCount: eventUsersCount ?? this.eventUsersCount,
        );
    }

    factory Event.fromJson(Map<String, dynamic> json){ 
        return Event(
            id: json["id"],
            activity: json["activity"],
            title: json["title"],
            slug: json["slug"],
            description: json["description"],
            imagePath: json["image_path"],
            imageUrl: json["image_url"],
            latitude: json["latitude"],
            longitude: json["longitude"],
            country: json["country"],
            province: json["province"],
            district: json["district"],
            subdistrict: json["subdistrict"],
            village: json["village"],
            postcode: json["postcode"],
            datetime: DateTime.tryParse(json["datetime"] ?? ""),
            price: json["price"],
            quota: json["quota"],
            isPublic: json["is_public"],
            isAutoPostToClub: json["is_auto_post_to_club"],
            cancelledAt: json["cancelled_at"],
            isOwner: json["is_owner"],
            isJoined: json["is_joined"],
            user: json["user"] == null ? null : User.fromJson(json["user"]),
            eventUsers: json["event_users"] == null ? [] : List<EventUser>.from(json["event_users"]!.map((x) => EventUser.fromJson(x))),
            eventUsersCount: json["event_users_count"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "activity": activity,
        "title": title,
        "slug": slug,
        "description": description,
        "image_path": imagePath,
        "image_url": imageUrl,
        "latitude": latitude,
        "longitude": longitude,
        "country": country,
        "province": province,
        "district": district,
        "subdistrict": subdistrict,
        "village": village,
        "postcode": postcode,
        "datetime": datetime?.toIso8601String(),
        "price": price,
        "quota": quota,
        "is_public": isPublic,
        "is_auto_post_to_club": isAutoPostToClub,
        "cancelled_at": cancelledAt,
        "is_owner": isOwner,
        "is_joined": isJoined,
        "user": user?.toJson(),
        "event_users": eventUsers.map((x) => x?.toJson()).toList(),
        "event_users_count": eventUsersCount,
    };

    @override
    List<Object?> get props => [
    id, activity, title, slug, description, imagePath, imageUrl, latitude, longitude, country, province, district, subdistrict, village, postcode, datetime, price, quota, isPublic, isAutoPostToClub, cancelledAt, isOwner, isJoined, user, eventUsers, eventUsersCount, ];
}

class EventUser extends Equatable {
    EventUser({
        required this.id,
        required this.status,
        required this.statusText,
        required this.user,
    });

    final String? id;
    final int? status;
    final String? statusText;
    final User? user;

    EventUser copyWith({
        String? id,
        int? status,
        String? statusText,
        User? user,
    }) {
        return EventUser(
            id: id ?? this.id,
            status: status ?? this.status,
            statusText: statusText ?? this.statusText,
            user: user ?? this.user,
        );
    }

    factory EventUser.fromJson(Map<String, dynamic> json){ 
        return EventUser(
            id: json["id"],
            status: json["status"],
            statusText: json["status_text"],
            user: json["user"] == null ? null : User.fromJson(json["user"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "status_text": statusText,
        "user": user?.toJson(),
    };

    @override
    List<Object?> get props => [
    id, status, statusText, user, ];
}

class User extends Equatable {
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

    factory User.fromJson(Map<String, dynamic> json){ 
        return User(
            id: json["id"],
            name: json["name"],
            imagePath: json["image_path"],
            imageUrl: json["image_url"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_path": imagePath,
        "image_url": imageUrl,
    };

    @override
    List<Object?> get props => [
    id, name, imagePath, imageUrl, ];
}
