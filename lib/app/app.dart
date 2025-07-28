import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/services/storage_service.dart';
import 'package:zest_mobile/app/core/shared/theme/app_theme.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';
import 'package:zest_mobile/app/core/values/storage_keys.dart';
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
        final token = sl<StorageService>().read(StorageKeys.token);

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
        } else if (
            uri.host == "share-club" &&
            uri.queryParameters['club'] != null &&
            token != null
        ) {
          Get.toNamed(AppRoutes.detailClub, arguments: uri.queryParameters['club']);
        } else if (
            uri.host == "share-profile" &&
            uri.queryParameters['user'] != null &&
            token != null
        ) {
          Get.toNamed(AppRoutes.profileUser, arguments: uri.queryParameters['user']);
        } else if (
            uri.host == "share-event" &&
            uri.queryParameters['event'] != null &&
            token != null
        ) {
          Get.toNamed(AppRoutes.socialYourPageEventDetail, arguments: {'eventId': uri.queryParameters['event']});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
          430, 932), // width dari Figma, height ambil estimasi layar panjang
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
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
            theme: TAppTheme.darkTheme,
            title: AppConstants.appName,
            builder: (context, widget) {
              ScreenUtil.init(context);
              return MediaQuery(
                data: MediaQuery.of(context),
                child: widget!,
              );
            },
          ),
        );
      },
    );
  }
}
