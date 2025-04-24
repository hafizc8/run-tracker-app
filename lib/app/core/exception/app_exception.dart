import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';

class AppException implements Exception {
  final AppExceptionType type;
  final String message;
  final int? statusCode;

  final Map<String, List<dynamic>>? errors; // for validation

  AppException({
    required this.type,
    required this.message,
    this.statusCode,
    this.errors,
  });

  @override
  String toString() => '[$type] $message';
}
