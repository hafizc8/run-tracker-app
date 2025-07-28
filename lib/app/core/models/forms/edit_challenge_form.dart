import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';
import 'package:zest_mobile/app/core/models/interface/mixin/form_model_mixin.dart';
import 'package:zest_mobile/app/core/models/interface/model_interface.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';

class EditChallengeFormModel extends FormModel<EditChallengeFormModel>
    with FormModelMixin<EditChallengeFormModel> {
  final String? title;
  final int? type;
  final int? mode;
  final int? target;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Teams>? teams;
  final List<String>? newTeams;
  final List<RenameTeam>? renameTeams;
  final List<String>? deleteTeams;
  final String? clubId;

  final Map<String, dynamic>? errors;

  EditChallengeFormModel({
    this.title,
    this.type = 0,
    this.mode = 0,
    this.target,
    this.startDate,
    this.endDate,
    this.teams = const [],
    this.newTeams = const [],
    this.renameTeams = const [],
    this.deleteTeams = const [],
    this.clubId,
    this.errors,
  });

  @override
  EditChallengeFormModel clearErrors() {
    return copyWith(errors: null);
  }

  @override
  EditChallengeFormModel copyWith({
    String? title,
    int? type,
    int? mode,
    int? target,
    bool? isEdit,
    DateTime? startDate,
    DateTime? endDate,
    List<Teams>? teams,
    List<String>? newTeams,
    List<RenameTeam>? renameTeams,
    List<String>? deleteTeams,
    String? clubId,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }
    return EditChallengeFormModel(
      title: title ?? this.title,
      type: type ?? this.type,
      mode: mode ?? this.mode,
      target: target ?? this.target,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      teams: teams ?? this.teams,
      newTeams: newTeams ?? this.newTeams,
      renameTeams: renameTeams ?? this.renameTeams,
      deleteTeams: deleteTeams ?? this.deleteTeams,
      clubId: clubId ?? this.clubId,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [
        type,
        mode,
        target,
        startDate,
        endDate,
        teams,
        errors,
        clubId,
        title,
        newTeams,
        renameTeams,
        deleteTeams
      ];

  @override
  EditChallengeFormModel setErrors(Map<String, List> errorsMap) {
    Map<String, dynamic> newErrors = {
      for (final entry in errorsMap.entries) entry.key: entry.value.first
    };

    return copyWith(
      errors: newErrors,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'start_date': startDate != null
          ? DateFormat('yyyy-MM-dd').format(startDate!)
          : null,
      if (mode == 0) 'target': target,
      if (mode == 1)
        'end_date':
            endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null,
      if (clubId != null) 'record_activity_id': clubId,
      'new_teams': newTeams,
      'rename_teams': renameTeams?.map((e) => e.toJson()).toList(),
      'delete_teams': deleteTeams,
      '_method': 'put',
    };
  }

  @override
  bool isValidToUpdate(EditChallengeFormModel formHasEdited) {
    return title != formHasEdited.title ||
        type != formHasEdited.type ||
        mode != formHasEdited.mode ||
        target != formHasEdited.target ||
        startDate != formHasEdited.startDate ||
        endDate != formHasEdited.endDate ||
        teams != formHasEdited.teams ||
        clubId != formHasEdited.clubId;
  }
}

class Teams extends Equatable {
  final String? id;
  final String? name;
  final bool? isEdit;
  final bool? isOwner;
  final List<User>? members;
  const Teams({
    this.id,
    this.name,
    this.members,
    this.isOwner,
    this.isEdit,
  });

  Teams copyWith({
    String? id,
    String? name,
    List<User>? members,
    bool? isEdit,
    bool? isOwner,
  }) {
    return Teams(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      isOwner: isOwner ?? this.isOwner,
      isEdit: isEdit ?? this.isEdit,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        members,
        isOwner,
        isEdit,
      ];
}

class RenameTeam extends Model {
  final String? oldName;
  final String? newName;

  RenameTeam({
    this.oldName,
    this.newName,
  });

  @override
  RenameTeam copyWith({
    String? oldName,
    String? newName,
  }) {
    return RenameTeam(
      oldName: oldName ?? this.oldName,
      newName: newName ?? this.newName,
    );
  }

  factory RenameTeam.fromJson(Map<String, dynamic> json) {
    return RenameTeam(
      oldName: json['old'],
      newName: json['new'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'old': oldName,
      'new': newName,
    };
  }

  @override
  List<Object?> get props => [oldName, newName];
}
