import 'dart:io';

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';
import 'package:zest_mobile/app/modules/share/levelup/views/share_levelup_card.dart';
import 'package:zest_mobile/app/modules/share/widgets/share_image_wrapper.dart';

class ShareLevelUpController extends GetxController {
  
  final String title;
  final String description;
  final String imageUrl;

  ShareLevelUpController({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  final ScreenshotController screenshotController = ScreenshotController();
  final AppinioSocialShare socialShare = AppinioSocialShare();
  RxBool isLoading = RxBool(false);

  final AuthService _authService = sl<AuthService>();
  UserModel? get user => _authService.user;
  
  @override
  void onInit() {
    super.onInit();

    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Minta Izin Activity Recognition
    await [
      Permission.storage,
      Permission.manageExternalStorage,
      Permission.photos,
    ].request();
  }

  /// ✨ FUNGSI UTAMA: Menangkap gambar dan membagikannya
  Future<void> shareTo(String platform) async {
    // 1. Tangkap widget sebagai gambar (dalam format Uint8List)
    final imageBytes = await screenshotController.captureFromWidget(
      ShareImageWrapper(
        shareCard: ShareLevelupCard(
          title: title,
          description: description,
          imageUrl: imageUrl,
        ),
        backgroundImagePath: 'assets/images/background_share-2.png',
      ),
      pixelRatio: 8.0,
    );

    // 2. Simpan gambar ke file sementara
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/shared_levelup_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = await File(imagePath).create();
    await file.writeAsBytes(imageBytes);

    String message = AppConstants.shareProfileLink(user?.id ?? '');

    switch (platform.toLowerCase()) {
      case 'whatsapp':
        await socialShare.android.shareToWhatsapp(message, imagePath);
        break;

      case 'instagram':
        await socialShare.android.shareToInstagramDirect(message);
        break;

      case 'x':
        await socialShare.android.shareToTwitter(message, imagePath);
        break;

      case 'link':
        // save message to clipboard
        await Clipboard.setData(ClipboardData(text: message));
        Get.snackbar('Success', 'Link copied to clipboard.');
        break;

      case 'download':
        final result = await ImageGallerySaver.saveImage(imageBytes.buffer.asUint8List());
        
        if (result['isSuccess'] == false) {
          Get.snackbar('Error', 'Failed to save image to gallery.');
        } else {
          Get.snackbar('Success', 'Image saved to gallery.');
        }
        break;

      default:
        print("Unknown share platform: $platform");
    }
  }
}