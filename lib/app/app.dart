import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/services/app_link_service.dart';
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
  final _appLinkService = sl<AppLinkService>();
  
  @override
  void initState() {
    super.initState();
    // Proses link awal saat aplikasi pertama kali dibuka
    _handleAppLink(_appLinkService.initialUri); 
    // Terus dengarkan link baru saat aplikasi sudah berjalan
    _appLinks.uriLinkStream.listen((uri) => _handleAppLink(uri));
  }

  // ✨ Buat satu fungsi terpusat untuk menangani semua link ✨
  void _handleAppLink(Uri? uri) {
    if (uri == null) return;
    
    final token = sl<StorageService>().read(StorageKeys.token);

    // Tangani navigasi non-auth terlebih dahulu
    if (uri.host == "email-verified" && uri.queryParameters['verified'] == 'true') {
      Get.offAllNamed(AppRoutes.registerVerifyEmailSuccess);
      return;

    } else if (uri.host == "reset-password" && uri.queryParameters['token'] != null && uri.queryParameters['email'] != null) {
      Get.offAllNamed(AppRoutes.forgotPasswordSetNew, arguments: {
        'token': uri.queryParameters['token'],
        'email': uri.queryParameters['email']
      });
      return;
    }
    
    // Jika user belum login, jangan lanjutkan ke halaman share
    if (token == null) {
      // Arahkan ke login jika mencoba membuka link share tanpa token
      Get.offAllNamed(AppRoutes.login);
      return;
    }

    // Navigasi ke halaman home terlebih dahulu, lalu ke halaman detail
    // Ini memastikan halaman detail memiliki "induk" yang benar.
    Get.offAllNamed(AppRoutes.mainHome);
    
    // Gunakan Future.delayed(Duration.zero) untuk memastikan navigasi
    // detail terjadi setelah navigasi home selesai.
    Future.delayed(Duration.zero, () {
      if (uri.host == "share-club" && uri.queryParameters['club'] != null) {
        Get.toNamed(AppRoutes.detailClub, arguments: uri.queryParameters['club']);
      } else if (uri.host == "share-profile" && uri.queryParameters['user'] != null) {
        Get.toNamed(AppRoutes.profileUser, arguments: uri.queryParameters['user']);
      } else if (uri.host == "share-event" && uri.queryParameters['event'] != null) {
        Get.toNamed(AppRoutes.socialYourPageEventDetail, arguments: {'eventId': uri.queryParameters['event']});
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
