import 'package:zest_mobile/app/core/models/interface/form_model_interface.dart';

class ForgotPasswordFormModel extends FormModel<ForgotPasswordFormModel> {
  final String email;

  final Map<String, dynamic>? errors;

  ForgotPasswordFormModel({
    this.email = '',
    this.errors = const {},
  });

  @override
  ForgotPasswordFormModel clearErrors() {
    return copyWith(errors: null);
  }

  @override
  ForgotPasswordFormModel copyWith({
    String? email,
    Map<String, dynamic>? errors,
    String? field,
  }) {
    if (field != null) {
      final newErrors = Map<String, dynamic>.from(errors ?? {});
      newErrors.remove(field);
      errors = newErrors;
    }
    return ForgotPasswordFormModel(
      email: email ?? this.email,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [email, errors];

  @override
  ForgotPasswordFormModel setErrors(Map<String, List<dynamic>> errorsMap) {
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
    };
  }

  @override
  bool isValidToUpdate(ForgotPasswordFormModel formHasEdited) {
    throw UnimplementedError();
  }
}
