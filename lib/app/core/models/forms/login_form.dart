import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';

class LoginFormModel extends FormModel<LoginFormModel> {
  final String email;
  final String password;
  final Map<String, dynamic>? errors;
  final String fcmToken;

  LoginFormModel({
    this.email = '',
    this.password = '',
    this.errors = const {},
    this.fcmToken = '',
  });

  @override
  LoginFormModel clearErrors() {
    return copyWith(errors: null);
  }

  @override
  LoginFormModel copyWith({
    String? email,
    String? password,
    String? fcmToken,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }
    return LoginFormModel(
      email: email ?? this.email,
      password: password ?? this.password,
      fcmToken: fcmToken ?? this.fcmToken,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [email, password, errors, fcmToken];

  @override
  LoginFormModel setErrors(Map<String, List<dynamic>> errorsMap) {
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
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
    };
  }
}
