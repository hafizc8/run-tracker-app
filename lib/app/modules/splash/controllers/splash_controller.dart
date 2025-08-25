import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/services/app_link_service.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/storage_service.dart';
import 'package:zest_mobile/app/core/values/storage_keys.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SplashController extends GetxController {
  final _authService = sl<AuthService>();
  final _appLinkService = sl<AppLinkService>();
  final _appLinks = AppLinks();

  @override
  void onReady() {
    super.onReady();
    // Proses link awal saat aplikasi pertama kali dibuka
    _handleAppLink(_appLinkService.initialUri); 
    // Terus dengarkan link baru saat aplikasi sudah berjalan
    _appLinks.uriLinkStream.listen((uri) => _handleAppLink(uri));
  }

  // ✨ Buat satu fungsi terpusat untuk menangani semua link ✨
  void _handleAppLink(Uri? uri) {
    if (uri == null) {
      redirect();
      return;
    }
    
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
    Future.delayed(const Duration(seconds: 2), () {
      if (uri.host == "share-club" && uri.queryParameters['club'] != null) {
        Get.toNamed(AppRoutes.detailClub, arguments: uri.queryParameters['club']);
      } else if (uri.host == "share-profile" && uri.queryParameters['user'] != null) {
        Get.toNamed(AppRoutes.profileUser, arguments: uri.queryParameters['user']);
      } else if (uri.host == "share-event" && uri.queryParameters['event'] != null) {
        Get.toNamed(AppRoutes.socialYourPageEventDetail, arguments: {'eventId': uri.queryParameters['event']});
      } else if (uri.host == "share-post" && uri.queryParameters['post'] != null) {
        final postController = Get.put(PostController());
        postController.goToDetail(postId: uri.queryParameters['post'] ?? '', isFocusComment: false);
      } else if (uri.host == "share-challenge" && uri.queryParameters['challenge'] != null) {
        Get.toNamed(AppRoutes.challengedetails, arguments: {"challengeId": uri.queryParameters['challenge']});
      }
    });
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(milliseconds: 1000)); // opsional smooth

    if (_appLinkService.initialUri != null) {
      print("App opened via deep link. SplashController will not navigate.");
      return; 
    }
    
    if (_authService.isAuthenticated) {
      Get.offAllNamed(AppRoutes.mainHome);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
