import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';

class ResetPasswordFormModel extends FormModel<ResetPasswordFormModel> {
  final String email;
  final String password;
  final String passwordConfirmation;
  final String token;
  Map<String, dynamic>? errors;

  ResetPasswordFormModel({
    this.email = '',
    this.password = '',
    this.passwordConfirmation = '',
    this.token = '',
    this.errors = const {},
  });

  @override
  ResetPasswordFormModel clearErrors() {
    return copyWith(errors: null);
  }

  @override
  ResetPasswordFormModel copyWith({
    String? email,
    String? password,
    String? passwordConfirmation,
    String? token,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }
    return ResetPasswordFormModel(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      token: token ?? this.token,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        passwordConfirmation,
        token,
        errors,
      ];

  @override
  ResetPasswordFormModel setErrors(Map<String, List<dynamic>> errorsMap) {
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
      'token': token,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}
