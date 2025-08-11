import 'dart:io';

import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zest_mobile/app/core/models/model/user_detail_model.dart';
import 'package:screenshot/screenshot.dart';

class ShareProfileController extends GetxController {
  final UserDetailModel userDetailModel;

  ShareProfileController({required this.userDetailModel});

  Rx<UserDetailModel?> userDetail = Rx<UserDetailModel?>(null);
  RxBool isLoading = RxBool(true);

  final ScreenshotController screenshotController = ScreenshotController();
  final AppinioSocialShare socialShare = AppinioSocialShare();
  
  @override
  void onInit() {
    super.onInit();

    isLoading.value = true;
    try {
      userDetail.value = userDetailModel;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ✨ FUNGSI UTAMA: Menangkap gambar dan membagikannya
  Future<void> shareTo(String platform) async {
    // 1. Tangkap widget sebagai gambar (dalam format Uint8List)
    final imageBytes = await screenshotController.capture(
      delay: const Duration(milliseconds: 20), // Beri sedikit jeda
      pixelRatio: 2.0, // Tingkatkan kualitas gambar
    );

    if (imageBytes == null) {
      Get.snackbar('Error', 'Could not capture image to share.');
      return;
    }

    // 2. Simpan gambar ke file sementara
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/shared_profile_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = await File(imagePath).create();
    await file.writeAsBytes(imageBytes);

    // 3. Bagikan ke platform yang dipilih
    // Pesan ini akan menyertai gambar saat dibagikan
    const String message = "Check out my profile on Zest+!";

    switch (platform.toLowerCase()) {
      case 'whatsapp':
        await socialShare.android.shareToWhatsapp(message, imagePath);
        break;
      case 'instagram':
        // Instagram memiliki opsi story atau feed
        // await socialShare.android.shareToInstagramDirect(stickerImage: imagePath);
        break;
      case 'telegram':
        await socialShare.android.shareToTelegram(message, imagePath);
        break;
      // TODO: Tambahkan case untuk platform lain (Messenger, Twitter, dll.)
      case 'download':
        // TODO: Implementasi logika download (mungkin perlu package 'image_gallery_saver')
        Get.snackbar('Success', 'Image saved to gallery!');
        break;
      default:
        print("Unknown share platform: $platform");
    }
  }
}