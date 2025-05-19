import 'package:zest_mobile/app/core/models/interface/model_interface.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';

// ignore: must_be_immutable
class ClubMemberModel extends Model<ClubMemberModel> {
    ClubMemberModel({
      required this.id,
      required this.role,
      required this.roleText,
      required this.status,
      required this.statusText,
      required this.user,
    });

    final String? id;
    final int? role;
    final String? roleText;
    final int? status;
    final String? statusText;
    final UserMiniModel? user;

    @override
  ClubMemberModel copyWith({
        String? id,
        int? role,
        String? roleText,
        int? status,
        String? statusText,
        UserMiniModel? user,
    }) {
        return ClubMemberModel(
          id: id ?? this.id,
          role: role ?? this.role,
          roleText: roleText ?? this.roleText,
          status: status ?? this.status,
          statusText: statusText ?? this.statusText,
          user: user ?? this.user
        );
    }

    factory ClubMemberModel.fromJson(Map<String, dynamic> json){ 
        return ClubMemberModel(
            id: json["id"],
            role: json["role"],
            roleText: json["role_text"],
            status: json["status"],
            statusText: json["status_text"],
            user: json["user"] == null ? null : UserMiniModel.fromJson(json["user"]),
        );
    }

    @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "role_text": roleText,
        "status": status,
        "status_text": statusText,
        "user": user?.toJson(),
    };

    @override
    List<Object?> get props => [
      id, role, roleText, status, statusText, user
    ];
}