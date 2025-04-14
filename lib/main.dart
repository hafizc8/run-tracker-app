import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'app/app.dart';

void main() async {
  setupServiceLocator();
  await GetStorage.init();
  runApp(const App());
}
