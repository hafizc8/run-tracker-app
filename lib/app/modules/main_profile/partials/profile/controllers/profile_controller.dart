import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/user_detail_model.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';

class ProfileController extends GetxController {
  final String userId;

  ProfileController({required this.userId});

  var activeIndex = 0.obs;

  final _userService = sl<UserService>();

  Rx<UserDetailModel?> user = Rx<UserDetailModel?>(null);

  RxBool isLoading = false.obs;
  RxBool isLoadingFollowUnfollow = false.obs;

  @override
  void onInit() {
    getDetailUser();
    super.onInit();
  }

  Future<void> getDetailUser() async {
    try {
      isLoading.value = true;
      user.value = await _userService.detailUser(userId);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> follow() async {
    try {
      isLoadingFollowUnfollow.value = true;
      bool res = await _userService.followUser(userId);
      if (res) {
        await getDetailUser();
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingFollowUnfollow.value = false;
    }
  }

  Future<void> unfollow() async {
    try {
      isLoadingFollowUnfollow.value = true;
      bool res = await _userService.unFollowUser(userId);
      if (res) {
        await getDetailUser();
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingFollowUnfollow.value = false;
    }
  }
}
