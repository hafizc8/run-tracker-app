import 'package:equatable/equatable.dart';

abstract class FormModel<T> extends Equatable {
  Map<String, dynamic> toJson();
  T copyWith();

  T setErrors(Map<String, List<dynamic>> errorsMap);
  T clearErrors();

  @override
  bool? get stringify => true;
}
