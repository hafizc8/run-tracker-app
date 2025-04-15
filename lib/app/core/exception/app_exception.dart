import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';

class AppException implements Exception {
  final AppExceptionType type;
  final String message;
  final int? statusCode;

  AppException({
    required this.type,
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => '[$type] $message';
}
