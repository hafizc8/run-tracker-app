import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/enums/leaderboard_top_walkers_page_enum.dart';
import 'package:zest_mobile/app/core/models/model/leaderboard_response_model.dart';
import 'package:zest_mobile/app/core/models/model/leaderboard_user_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/leaderboard_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';

class ClubLeaderboardTabController extends GetxController {
  Rx<LeaderboardTopWalkersPageEnum> selectedChip = LeaderboardTopWalkersPageEnum.global.obs;

  RxBool isFriendsOnly = false.obs;

  final LeaderboardService _leaderboardService = sl<LeaderboardService>();
  RxList<LeaderboardUserModel> leaderboards = <LeaderboardUserModel>[].obs;
  RxInt pageLeaderboard = 1.obs;
  RxBool isLoadingGetLeaderboard = false.obs;
  RxBool hasReacheMax = false.obs;
  Rx<LeaderboardUserModel?> me = Rx<LeaderboardUserModel?>(null);
  RxString areaFilter = ''.obs;

  final clubLeaderboardScrollController = ScrollController();
  final _debouncer = Debouncer(milliseconds: 500);

  // ✨ --- State Baru untuk Floating Widget --- ✨
  var showFloatingRank = false.obs;
  // Flag untuk menandai apakah peringkat user di luar jangkauan awal
  var isMyRankOffscreen = false.obs;
  // Threshold untuk menentukan kapan rank dianggap "jauh"
  final int floatingRankThreshold = 10;

  final AuthService _authService = sl<AuthService>();
  UserModel? get user => _authService.user;

  var clubId = ''.obs;


  @override
  void onInit() {
    super.onInit();
    clubId.value = Get.arguments as String;
    getLeaderboard();

    clubLeaderboardScrollController.addListener(() {
      final position = clubLeaderboardScrollController.position;

      bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;

      print('isNearBottom: $isNearBottom');
      print('position.pixels: ${position.pixels} position.maxScrollExtent: ${position.maxScrollExtent - 200}');

      _debouncer.run(() {
        if (isNearBottom && !isLoadingGetLeaderboard.value && !hasReacheMax.value) {
          getLeaderboard();
        }
      });
    });
  }

  @override
  void onClose() {
    clubLeaderboardScrollController.dispose();
    super.onClose();
  }

  dynamic selectChip(LeaderboardTopWalkersPageEnum chip) {
    selectedChip.value = chip;
    if (selectedChip.value == LeaderboardTopWalkersPageEnum.global) {
      areaFilter.value = '';
    } else if (selectedChip.value == LeaderboardTopWalkersPageEnum.country) {
      areaFilter.value = user?.country ?? '';
    } else if (selectedChip.value == LeaderboardTopWalkersPageEnum.province) {
      areaFilter.value = user?.province ?? '';
    } else if (selectedChip.value == LeaderboardTopWalkersPageEnum.regency) {
      areaFilter.value = user?.district ?? '';
    } else if (selectedChip.value == LeaderboardTopWalkersPageEnum.district) {
      areaFilter.value = user?.subdistrict ?? '';
    }

    refreshLeaderboard();
  }

  Future<void> refreshLeaderboard() async {
    pageLeaderboard.value = 1;
    hasReacheMax.value = false;
    leaderboards.clear();
    me.value = null;
    await getLeaderboard();
  }

  Future<void> getLeaderboard() async {
    if (isLoadingGetLeaderboard.value || hasReacheMax.value) return;

    try {
      isLoadingGetLeaderboard.value = true;

      LeaderboardResponseModel response = await _leaderboardService.getLeaderboard(
        page: pageLeaderboard.value,
        locationLevel: selectedChip.value.value,
        friendOnly: isFriendsOnly.value,
        clubId: clubId.value,
      );

      // Deteksi akhir halaman dengan lebih akurat
      if (
          (response.leaderboards?.pagination.next == null || response.leaderboards!.pagination.next!.isEmpty) ||
          response.leaderboards!.data.isEmpty ||
          response.leaderboards!.data.length < 20
      ) {
        hasReacheMax.value = true;
      }

      me.value = response.me;

      // Tambahkan hasil ke list
      leaderboards += response.leaderboards?.data ?? [];

      // Increment page terakhir
      pageLeaderboard++;
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingGetLeaderboard.value = false;

      if (me.value != null) {
        onLeaderboardDataReady();
      }
    }
  }

  void onLeaderboardDataReady() {
    final myRank = me.value?.rank;
    if (myRank != null && myRank > floatingRankThreshold) {
      isMyRankOffscreen.value = true;
      showFloatingRank.value = true;
    } else {
      isMyRankOffscreen.value = false;
      showFloatingRank.value = false;
    }
  }

  void onMyRankVisibilityChanged(bool isVisible) {
    // Tampilkan floating rank hanya jika peringkat user jauh DAN widget aslinya tidak terlihat
    if (isMyRankOffscreen.value) {
      showFloatingRank.value = !isVisible;
    }
  }
}