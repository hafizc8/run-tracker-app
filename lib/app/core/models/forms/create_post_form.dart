import 'dart:io';
import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';
import 'package:zest_mobile/app/core/models/interface/mixin/form_model_mixin.dart';

class CreatePostFormModel extends FormModel<CreatePostFormModel> with FormModelMixin<CreatePostFormModel> {
  final String? content;
  final double? latitude;
  final double? longitude;
  final List<File>? galleries;

  final Map<String, dynamic>? errors;

  CreatePostFormModel({
    this.content,
    this.latitude,
    this.longitude,
    this.galleries,
    this.errors,
  });

  @override
  CreatePostFormModel clearErrors() {
    return copyWith(errors: null);
  }

  @override
  CreatePostFormModel copyWith({
    String? content,
    double? latitude,
    double? longitude,
    List<File>? galleries,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }
    return CreatePostFormModel(
      content: content ?? this.content,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      galleries: galleries ?? this.galleries,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [content, latitude, longitude, galleries];

  @override
  CreatePostFormModel setErrors(Map<String, List> errorsMap) {
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
      'content': content,
      'latitude': latitude,
      'longitude': longitude,
      'galleries': galleries,
    };
  }
  
  @override
  bool isValidToUpdate(CreatePostFormModel formHasEdited) {
    throw UnimplementedError();
  }
}