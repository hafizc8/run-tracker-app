import 'dart:io';

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/unit_helper.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';
import 'package:zest_mobile/app/modules/share/activity/views/share_activity_card.dart';
import 'package:zest_mobile/app/modules/share/widgets/share_image_wrapper.dart';

class ShareActivityController extends GetxController {
  final PostModel postModel;

  ShareActivityController({required this.postModel});

  Rx<PostModel?> postData = Rx<PostModel?>(null);
  final unitHelper = sl<UnitHelper>();
  RxBool isLoading = RxBool(true);

  final ScreenshotController screenshotController = ScreenshotController();
  final AppinioSocialShare socialShare = AppinioSocialShare();
  
  @override
  void onInit() {
    super.onInit();

    isLoading.value = true;
    try {
      postData.value = postModel;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }

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
        shareCard: ShareActivityCard(
          postModel: postModel,
          distanceInFormat: unitHelper.formatDistance(postModel.recordActivity?.lastRecordActivityLog?.distance ?? 0),
        ),
        backgroundImagePath: 'assets/images/background_share-2.png',
      ),
      pixelRatio: 4.0,
    );

    // 2. Simpan gambar ke file sementara
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/shared_activity_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = await File(imagePath).create();
    await file.writeAsBytes(imageBytes);

    String message = ''; //AppConstants.sharePostLink(postModel.id!);

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
          stickerImage: imagePath,
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
          Get.snackbar('Error', 'Twitter or X is not installed on this device.');
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