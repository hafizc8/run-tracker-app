import 'package:zest_mobile/app/core/models/enums/gender_enum.dart';
import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';

class RegisterCreateProfileFormModel
    extends FormModel<RegisterCreateProfileFormModel> {
  final String name;
  final double latitude;
  final double longitude;
  final String birthday;
  final GenderEnum gender;

  Map<String, dynamic>? errors;

  RegisterCreateProfileFormModel({
    this.name = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.birthday = '',
    this.gender = GenderEnum.unknown,
    this.errors = const {},
  });

  bool get isValid => latitude != 0.0 && longitude != 0.0;

  @override
  RegisterCreateProfileFormModel clearErrors() {
    return copyWith(errors: null);
  }

  @override
  RegisterCreateProfileFormModel copyWith({
    String? name,
    double? latitude,
    double? longitude,
    String? birthday,
    GenderEnum? gender,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }
    return RegisterCreateProfileFormModel(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [
        name,
        latitude,
        longitude,
        birthday,
        gender,
        errors,
      ];

  @override
  RegisterCreateProfileFormModel setErrors(
      Map<String, List<dynamic>> errorsMap) {
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
      'latitude': latitude,
      'longitude': longitude,
      'birthday': birthday,
      'gender': gender.toValue,
    };
  }
}
