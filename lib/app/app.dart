import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:zest_mobile/app/core/shared/theme/app_theme.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';
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
      if (uri != null && uri.scheme == "devzestplus") {
        if (uri.host == "email-verified" &&
            uri.queryParameters['verified'] == 'true') {
          Get.offAllNamed(AppRoutes.registerVerifyEmailSuccess);
        } else if (uri.host == "reset-password" &&
            uri.queryParameters['token'] != null &&
            uri.queryParameters['email'] != null) {
          Get.offAllNamed(AppRoutes.forgotPasswordSetNew, arguments: {
            'token': uri.queryParameters['token'],
            'email': uri.queryParameters['email']
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayWidgetBuilder: (_) => Center(
        child: CircularProgressIndicator(
          color: lightColorScheme.primary,
        ),
      ),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
        theme: TAppTheme.lightTheme,
        title: AppConstants.appName,
      ),
    );
  }
}
