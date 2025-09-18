import 'dart:io';
import 'package:appinio_social_share/appinio_social_share.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/challenge_detail_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';
import 'package:zest_mobile/app/modules/share/challenge_progress_individual/views/share_challenge_progress_individual_card.dart';
import 'package:zest_mobile/app/modules/share/widgets/share_image_wrapper.dart';

class ShareChallengeProgressIndividualController extends GetxController {
  
  final ChallengeDetailModel challengeModel;

  ShareChallengeProgressIndividualController({required this.challengeModel});

  Rx<ChallengeDetailModel?> challengeData = Rx<ChallengeDetailModel?>(null);
  RxBool isLoading = RxBool(true);

  final ScreenshotController screenshotController = ScreenshotController();
  final AppinioSocialShare socialShare = AppinioSocialShare();

  final AuthService _authService = sl<AuthService>();
  UserModel? get user => _authService.user;
  
  @override
  void onInit() {
    super.onInit();

    isLoading.value = true;
    try {
      challengeData.value = challengeModel;
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
        shareCard: ShareChallengeProgressIndividualCard(
          challengeModel: challengeData.value!,
          list4TopWalker: getUsersToShow(),
          currentUser: user!,
          isSmallWidthScreen: MediaQuery.of(Get.context!).size.width <= 360,
        ),
        backgroundImagePath: 'assets/images/share_challenge_individual_background.jpg',
        wrapperWidth: MediaQuery.of(Get.context!).size.width,
        wrapperHeight: MediaQuery.of(Get.context!).size.height,
      ),
      pixelRatio: 2.0,
    );

    // 2. Simpan gambar ke file sementara
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/shared_challenge_individual_progress_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = await File(imagePath).create();
    await file.writeAsBytes(imageBytes);

    String message = ''; //AppConstants.shareChallengeLink(challengeModel.id!);

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

  List<LeaderboardUser> getUsersToShow() {
    final allUsers = challengeModel.leaderboardUsers;
    // 1. Ambil pengguna saat ini
    
    final String currentUserId = user?.id ?? '';

    // 2. Ambil sisa peringkat (mulai dari peringkat 4)
    final restOfUsers = allUsers.skip(3).toList();

    // 3. Cari data pengguna yang sedang login di dalam sisa peringkat
    final currentUserData = restOfUsers.firstWhereOrNull((user) => user.user?.id == currentUserId);

    // 4. Buat daftar awal untuk ditampilkan (peringkat 4-8)
    // Saring agar pengguna saat ini tidak muncul dua kali jika ia berada di peringkat 4-8
    final List<LeaderboardUser> displayList = restOfUsers
        .where((user) => user.user?.id != currentUserId)
        .take(5) // Ambil 5 peringkat teratas dari sisa pengguna
        .toList();
        
    // 5. Tambahkan pengguna saat ini di akhir daftar JIKA ia ada dan tidak termasuk dalam 5 besar
    if (currentUserData != null) {
      // Cek apakah currentUserData sudah ada di dalam displayList
      bool isCurrentUserInList = displayList.any((user) => user.user?.id == currentUserId);
      
      if (!isCurrentUserInList) {
        displayList.add(currentUserData);
      }
    }

    // Atur ulang daftar berdasarkan peringkat
    displayList.sort((a, b) => (a.rank ?? 0).compareTo(b.rank ?? 0));
    
    return displayList;
  }

}