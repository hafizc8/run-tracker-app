import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_club_search_controller.dart';

class DetailClubController extends GetxController {
  var clubId = ''.obs;

  Rx<ClubModel?> club = Rx<ClubModel?>(null);
  RxBool isLoading = false.obs;

  final ClubService _clubService = sl<ClubService>();

  @override
  void onInit() {
    super.onInit();
    clubId.value = Get.arguments as String;
  }

  @override
  void onReady() {
    super.onReady();
    loadDetail();
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

  Future<void> leaveClub() async {
    Get.defaultDialog(
      title: 'Leave Club',
      middleText: 'Are you sure to leave from club?',
      textCancel: 'Back',
      textConfirm: 'Yes, leave',
      confirmTextColor: Colors.white,
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.symmetric(vertical: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onConfirm: () async {
        isLoading.value = true;
        try {
          bool resp = await _clubService.accOrJoinOrLeave(
              clubId: clubId.value, leave: 1);
          if (resp) {
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
          isLoading.value = false;
        }
      },
    );
  }
}
