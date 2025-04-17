import 'package:equatable/equatable.dart';

abstract class Model<T> extends Equatable {
  Map<String, dynamic> toJson();
  T copyWith();

  @override
  bool? get stringify => true;
}
