import 'dart:io';

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';
import 'package:zest_mobile/app/modules/share/daily_streak/views/share_daily_streak_card.dart';
import 'package:zest_mobile/app/modules/share/widgets/share_image_wrapper.dart';

class ShareDailyStreakController extends GetxController {
  
  final String title;
  final String description;
  final String imageUrl;

  ShareDailyStreakController({
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
        shareCard: ShareDailySteakCard(
          title: title,
          description: description,
          imageUrl: imageUrl,
        ),
        backgroundImagePath: 'assets/images/background_share-2.png',
        wrapperWidth: MediaQuery.of(Get.context!).size.width,
        wrapperHeight: MediaQuery.of(Get.context!).size.height,
      ),
      pixelRatio: 2.0,
    );

    // 2. Simpan gambar ke file sementara
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/shared_dailystreak_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = await File(imagePath).create();
    await file.writeAsBytes(imageBytes);

    String message = ''; //AppConstants.shareProfileLink(user?.id ?? '');

    final installedApps = await socialShare.getInstalledApps();

    switch (platform.toLowerCase()) {
      case 'whatsapp':
        if (installedApps['whatsapp'] == false) {
          Get.snackbar('Error', 'WhatsApp is not installed on this device.');
          return;
        }
        await socialShare.android.shareToWhatsapp(message, imagePath);
        break;

      case 'ig story':
        if (installedApps['instagram'] == false) {
          Get.snackbar('Error', 'Instagram is not installed on this device.');
          return;
        }
        await socialShare.android.shareToInstagramStory(
          AppConstants.facebookAppId, 
          backgroundImage: imagePath,
        );
        break;

      case 'ig feed':
        if (installedApps['instagram'] == false) {
          Get.snackbar('Error', 'Instagram is not installed on this device.');
          return;
        }
        await socialShare.android.shareToInstagramFeed(message, imagePath);
        break;

      case 'x':
        if (installedApps['twitter'] == false) {
          Get.snackbar('Error', 'X (Twitter) is not installed on this device.');
          return;
        }
        await socialShare.android.shareToTwitter(message, imagePath);
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