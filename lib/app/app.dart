import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/routes/app_pages.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';
import 'package:zest_mobile/app/core/values/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      theme: AppTheme.lightTheme,
      title: 'Zest Mobile',
    );
  }
}