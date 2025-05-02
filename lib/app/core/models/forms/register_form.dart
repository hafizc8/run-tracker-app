import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';

class RegisterFormModel extends FormModel<RegisterFormModel> {
  final String email;
  final String password;
  final String passwordConfirmation;
  final bool isAgree;
  final Map<String, dynamic>? errors;

  RegisterFormModel({
    this.email = '',
    this.password = '',
    this.passwordConfirmation = '',
    this.isAgree = false,
    this.errors = const {},
  });

  @override
  RegisterFormModel clearErrors() {
    return copyWith(errors: null);
  }

  @override
  RegisterFormModel copyWith({
    String? email,
    String? password,
    String? passwordConfirmation,
    bool? isAgree,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }
    return RegisterFormModel(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      isAgree: isAgree ?? this.isAgree,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        passwordConfirmation,
        isAgree,
        errors,
      ];

  @override
  RegisterFormModel setErrors(Map<String, List<dynamic>> errorsMap) {
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
      'password_confirmation': passwordConfirmation,
      'is_agree': isAgree,
    };
  }

  @override
  bool isValidToUpdate(RegisterFormModel formHasEdited) {
    throw UnimplementedError();
  }
}
