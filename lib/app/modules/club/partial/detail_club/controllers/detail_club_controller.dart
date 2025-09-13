import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/controllers/club_activity_tab_controller.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/controllers/club_leaderboard_tab_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_club_search_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/widget/confirmation.dart';

class DetailClubController extends GetxController {
  var clubId = ''.obs;

  Rx<ClubModel?> club = Rx<ClubModel?>(null);
  RxBool isLoading = false.obs;
  RxBool isLoadingAction = false.obs;
  RxBool isLoadingMute = false.obs;
  var tabs = ['Club Activity', 'Leaderboards'].obs;

  final ClubService _clubService = sl<ClubService>();

  var isExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is String) {
      clubId.value = Get.arguments as String;
    } else {
      Future.delayed(Duration.zero, () {
        Get.snackbar("Error", "Could not load data");
        if (Get.previousRoute.isNotEmpty) {
          Get.back(closeOverlays: true);
        }
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
    loadDetail();
  }

  // on refresh
  Future<void> onRefresh() async {
    loadDetail();

    Get.find<ClubActivityTabController>().getClubActivity();
    Get.find<ClubLeaderboardTabController>().getLeaderboard();
  }

  Future<void> loadDetail() async {
    try {
      isLoading.value = true;
      ClubModel resp = await _clubService.getDetail(clubId: clubId.value);
      club.value = resp;
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    loadDetail();
  }

  Future<void> confirmCancelEvent() async {
    await Get.dialog(
      Obx(
        () => ConfirmationDialog(
          onConfirm: () => leaveClub(),
          title: 'Leaving Club',
          subtitle: 'Are you sure to leave from club?',
          labelConfirm: 'Yes, leave',
          isLoading: isLoadingAction.value,
        ),
      ),
    );
  }

  Future<void> leaveClub() async {
    isLoadingAction.value = true;
    try {
      bool resp =
          await _clubService.accOrJoinOrLeave(clubId: clubId.value, leave: 1);
      if (resp) {
        Get.back();
        Get.back();
        Get.snackbar("Success", "Successfully leave club");

        // refresh SocialClubSearchController
        Get.find<SocialClubSearchController>().load(refresh: true);
      }
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingAction.value = false;
    }
  }

  Future<void> confirmMuteClub({required bool isMuted}) async {
    await Get.dialog(
      Obx(
        () => ConfirmationDialog(
          onConfirm: () => muteClub(),
          title: isMuted ? 'Unmute Club' : 'Mute Club',
          subtitle: 'Are you sure to ${isMuted ? 'unmute' : 'mute'} this club?',
          labelConfirm: 'Yes, ${isMuted ? 'unmute' : 'mute'}',
          isLoading: isLoadingMute.value,
        ),
      ),
    );
  }

  Future<void> muteClub() async {
    isLoadingMute.value = true;
    try {
      final bool isMuted = club.value?.isMuted ?? false;

      bool resp = await _clubService.muteClub(
        clubId: clubId.value,
        unmute: isMuted,
      );
      if (resp) {
        // update isMuted
        club.value = club.value?.copyWith(isMuted: !isMuted);
        Get.back();
        Get.snackbar(
            "Success", "Successfully ${isMuted ? 'unmute' : 'mute'} club");
      }
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingMute.value = false;
    }
  }
}
