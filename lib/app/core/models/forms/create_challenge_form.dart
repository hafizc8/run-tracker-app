import 'dart:io';
import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';
import 'package:zest_mobile/app/core/models/interface/mixin/form_model_mixin.dart';

class CreateChallengeFormModel extends FormModel<CreateChallengeFormModel>
    with FormModelMixin<CreateChallengeFormModel> {
  final String? title;
  final int? type;
  final int? mode;
  final int? target;
  final List<File>? galleries;
  final String? recordActivityId;

  final Map<String, dynamic>? errors;

  CreateChallengeFormModel({
    this.title,
    this.type,
    this.mode,
    this.target,
    this.galleries,
    this.recordActivityId,
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
    List<File>? galleries,
    String? recordActivityId,
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
      galleries: galleries ?? this.galleries,
      recordActivityId: recordActivityId ?? this.recordActivityId,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props =>
      [type, mode, target, galleries, errors, recordActivityId, title];

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
      'target': target,
      'galleries': galleries,
      if (recordActivityId != null) 'record_activity_id': recordActivityId,
    };
  }

  @override
  bool isValidToUpdate(CreateChallengeFormModel formHasEdited) {
    throw UnimplementedError();
  }
}
