import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/theme/app_theme.dart';

import 'package:zest_mobile/app/routes/app_pages.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _appLinks = AppLinks();
  @override
  void initState() {
    super.initState();
    _listenDynamicLinks();
  }

  void _listenDynamicLinks() {
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null &&
          uri.scheme == "devzestplus" &&
          uri.host == "email-verified" &&
          uri.queryParameters['verified'] == 'true') {
        Get.offAllNamed(AppRoutes.registerVerifyEmailSuccess);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
      theme: TAppTheme.lightTheme,
      title: 'Zest Mobile',
    );
  }
}
