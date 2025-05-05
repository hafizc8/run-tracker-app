import 'dart:io';

import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';
import 'package:zest_mobile/app/core/models/interface/mixin/form_model_mixin.dart';

class UpdateUserFormModel extends FormModel<UpdateUserFormModel>
    with FormModelMixin<UpdateUserFormModel> {
  final String? name;
  final String? email;
  final String? gender;
  final String? bio;
  final DateTime? birthday;
  final double? latitude;
  final double? longitude;
  final File? image;

  final Map<String, dynamic>? errors;

  UpdateUserFormModel({
    this.name,
    this.email,
    this.gender,
    this.bio,
    this.birthday,
    this.latitude,
    this.longitude,
    this.image,
    this.errors,
  });

  @override
  UpdateUserFormModel clearErrors() {
    return copyWith(errors: null);
  }

  @override
  UpdateUserFormModel copyWith({
    String? name,
    String? bio,
    DateTime? birthday,
    double? latitude,
    double? longitude,
    File? image,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }
    return UpdateUserFormModel(
      name: name ?? this.name,
      email: email,
      gender: gender,
      bio: bio ?? this.bio,
      birthday: birthday ?? this.birthday,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      image: image ?? this.image,
      errors: errors ?? this.errors,
    );
  }

  @override
  bool isValidToUpdate(UpdateUserFormModel formHasEdited) {
    return name != formHasEdited.name ||
        bio != formHasEdited.bio ||
        birthday != formHasEdited.birthday ||
        latitude != formHasEdited.latitude ||
        longitude != formHasEdited.longitude ||
        image != formHasEdited.image;
  }

  @override
  List<Object?> get props => [name, bio, birthday, latitude, longitude, image];

  @override
  UpdateUserFormModel setErrors(Map<String, List> errorsMap) {
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
      'name': name,
      'bio': bio,
      'birthday': birthday,
      'latitude': latitude,
      'longitude': longitude,
      'image': image,
      '_method': 'put',
    };
  }
}
