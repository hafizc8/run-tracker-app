import 'dart:io';

import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';
import 'package:zest_mobile/app/core/models/interface/mixin/form_model_mixin.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';

class EditActivityForm extends FormModel<EditActivityForm> with FormModelMixin<EditActivityForm> {
  final String? recordActivityId;
  final String? title;
  final String? content;
  final List<File>? newGalleries;
  final List<String>? deletedGalleries;
  final List<Gallery>? currentGalleries;
  final double? latitude;
  final double? longitude;
  final File? galleryMap;

  final Map<String, dynamic>? errors;

  EditActivityForm({
    this.recordActivityId,
    this.title,
    this.content,
    this.newGalleries,
    this.deletedGalleries,
    this.currentGalleries,
    this.latitude,
    this.longitude,
    this.errors,
    this.galleryMap,
  });

  @override
  EditActivityForm clearErrors() {
    return copyWith(errors: null);
  }

  @override
  EditActivityForm copyWith({
    String? recordActivityId,
    String? title,
    String? content,
    List<File>? newGalleries,
    List<String>? deletedGalleries,
    List<Gallery>? currentGalleries,
    double? latitude,
    double? longitude,
    File? galleryMap,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }
    return EditActivityForm(
      recordActivityId: recordActivityId ?? this.recordActivityId,
      title: title ?? this.title,
      content: content ?? this.content,
      newGalleries: newGalleries ?? this.newGalleries,
      deletedGalleries: deletedGalleries ?? this.deletedGalleries,
      currentGalleries: currentGalleries ?? this.currentGalleries,
      galleryMap: galleryMap ?? this.galleryMap,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      errors: errors ?? this.errors,
    );
  }

  @override
  bool isValidToUpdate(EditActivityForm formHasEdited) {
    return true;
  }

  @override
  List<Object?> get props => [
    recordActivityId,
    title,
    content,
    newGalleries,
    deletedGalleries,
    currentGalleries,
    galleryMap,
    latitude,
    longitude,
    errors,
  ];

  @override
  EditActivityForm setErrors(Map<String, List> errorsMap) {
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
      'latitude': latitude,
      'longitude': longitude,
      'record_activity_id': recordActivityId,
      'gallery_map': galleryMap
    };

    return data;
  }
}
