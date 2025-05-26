import 'dart:io';

import 'package:zest_mobile/app/core/models/enums/club_post_permission_enum.dart';
import 'package:zest_mobile/app/core/models/enums/club_privacy_enum.dart';
import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';
import 'package:zest_mobile/app/core/models/interface/mixin/form_model_mixin.dart';

class UpdateClubFormModel extends FormModel<UpdateClubFormModel> with FormModelMixin<UpdateClubFormModel> {
  final String? id;
  final String? name;
  final String? description;
  final File? image;
  final String? city;
  final ClubPrivacyEnum? clubPrivacy;
  final ClubPostPermissionEnum? postPermission;
  final double? latitude;
  final double? longitude;
  final String? address;

  final Map<String, dynamic>? errors;

  UpdateClubFormModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.city,
    this.clubPrivacy,
    this.postPermission,
    this.latitude,
    this.longitude,
    this.address,
    this.errors,
  });

  @override
  UpdateClubFormModel clearErrors() {
    return copyWith(errors: null);
  }

  @override
  UpdateClubFormModel copyWith({
    String? id,
    String? name,
    String? description,
    File? image,
    String? city,
    ClubPrivacyEnum? clubPrivacy,
    ClubPostPermissionEnum? postPermission,
    double? latitude,
    double? longitude,
    String? address,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }
    return UpdateClubFormModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      city: city ?? this.city,
      clubPrivacy: clubPrivacy ?? this.clubPrivacy,
      postPermission: postPermission ?? this.postPermission,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      errors: errors ?? this.errors,
    );
  }

  @override
  bool isValidToUpdate(UpdateClubFormModel formHasEdited) {
    return name != formHasEdited.name ||
        description != formHasEdited.description ||
        image != formHasEdited.image ||
        city != formHasEdited.city ||
        clubPrivacy != formHasEdited.clubPrivacy ||
        postPermission != formHasEdited.postPermission;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        image,
        city,
        clubPrivacy,
        postPermission,
        latitude,
        longitude,
        address,
        errors,
      ];

  @override
  UpdateClubFormModel setErrors(Map<String, List> errorsMap) {
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
      'name': name,
      'description': description,
      'image': image,
      'city': city,
      'privacy': clubPrivacy?.toValue,
      'post_permission': postPermission?.toValue,
      '_method': 'put',
    };

    return data;
  }
}
