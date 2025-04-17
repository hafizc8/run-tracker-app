import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';

class AppExceptionHandlerInfo {
  static void handle(AppException appEx) {
    switch (appEx.type) {
      case AppExceptionType.unauthorized:
        break;
      case AppExceptionType.emailUnVerified:
        break;
      case AppExceptionType.emptyProfile:
        break;
      default:
        Get.snackbar('Error', appEx.message);
    }
  }
}
