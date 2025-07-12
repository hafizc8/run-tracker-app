import 'package:equatable/equatable.dart';
import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';
import 'package:zest_mobile/app/core/models/interface/mixin/form_model_mixin.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';

class CreateChallengeFormModel extends FormModel<CreateChallengeFormModel>
    with FormModelMixin<CreateChallengeFormModel> {
  final String? title;
  final int? type;
  final int? mode;
  final int? target;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<Teams>? teams;
  final String? clubId;

  final Map<String, dynamic>? errors;

  CreateChallengeFormModel({
    this.title,
    this.type = 0,
    this.mode = 0,
    this.target,
    this.startDate,
    this.endDate,
    this.teams,
    this.clubId,
    this.errors,
  });

  @override
  CreateChallengeFormModel clearErrors() {
    return copyWith(errors: null);
  }

  @override
  CreateChallengeFormModel copyWith({
    String? title,
    int? type,
    int? mode,
    int? target,
    DateTime? startDate,
    DateTime? endDate,
    List<Teams>? teams,
    String? clubId,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }
    return CreateChallengeFormModel(
      title: title ?? this.title,
      type: type ?? this.type,
      mode: mode ?? this.mode,
      target: target ?? this.target,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      teams: teams ?? this.teams,
      clubId: clubId ?? this.clubId,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props =>
      [type, mode, target, startDate, endDate, teams, errors, clubId, title];

  @override
  CreateChallengeFormModel setErrors(Map<String, List> errorsMap) {
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
      'type': type,
      'mode': mode,
      'start_date': startDate,
      if (mode == 0) 'target': target,
      if (mode == 1) 'end_date': endDate,
      'teams': teams,
      if (clubId != null) 'record_activity_id': clubId,
    };
  }

  @override
  bool isValidToUpdate(CreateChallengeFormModel formHasEdited) {
    throw UnimplementedError();
  }
}

class Teams extends Equatable {
  final String? teamName;
  final User? user;
  const Teams({
    this.teamName,
    this.user,
  });

  @override
  List<Object?> get props => [
        teamName,
      ];
}
