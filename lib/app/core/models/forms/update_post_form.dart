import 'dart:io';

import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';
import 'package:zest_mobile/app/core/models/interface/mixin/form_model_mixin.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';

class UpdatePostFormModel extends FormModel<UpdatePostFormModel> with FormModelMixin<UpdatePostFormModel> {
  final String? id;
  final String? title;
  final String? content;
  final List<File>? newGalleries;
  final List<String>? deletedGalleries;
  final List<Gallery>? currentGalleries;
  final bool? isFromDetail;

  final Map<String, dynamic>? errors;

  UpdatePostFormModel({
    this.id,
    this.title,
    this.content,
    this.newGalleries,
    this.deletedGalleries,
    this.currentGalleries,
    this.isFromDetail,
    this.errors,
  });

  @override
  UpdatePostFormModel clearErrors() {
    return copyWith(errors: null);
  }

  @override
  UpdatePostFormModel copyWith({
    String? id,
    String? title,
    String? content,
    List<File>? newGalleries,
    List<String>? deletedGalleries,
    List<Gallery>? currentGalleries,
    bool? isFromDetail,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }
    return UpdatePostFormModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      newGalleries: newGalleries ?? this.newGalleries,
      deletedGalleries: deletedGalleries ?? this.deletedGalleries,
      currentGalleries: currentGalleries ?? this.currentGalleries,
      isFromDetail: isFromDetail ?? this.isFromDetail,
      errors: errors ?? this.errors,
    );
  }

  @override
  bool isValidToUpdate(UpdatePostFormModel formHasEdited) {
    return title != formHasEdited.title ||
        content != formHasEdited.content ||
        newGalleries?.length != formHasEdited.newGalleries?.length ||
        deletedGalleries?.length != formHasEdited.deletedGalleries?.length ||
        currentGalleries?.length != formHasEdited.currentGalleries?.length;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        newGalleries,
        deletedGalleries,
        currentGalleries,
        errors,
      ];

  @override
  UpdatePostFormModel setErrors(Map<String, List> errorsMap) {
    Map<String, dynamic> newErrors = {
      for (final entry in errorsMap.entries) entry.key: entry.value.first
    };

    return copyWith(
      errors: newErrors,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'content': content,
      'galleries': newGalleries,
      '_method': 'put',
    };

    if (deletedGalleries != null) {
      for (int i = 0; i < deletedGalleries!.length; i++) {
        data['deleted_galleries[$i]'] = deletedGalleries![i];
      }
    }

    return data;
  }
}
