import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/models/model/user_detail_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/post_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';

class ProfileController extends GetxController {
  final String userId;

  ProfileController({required this.userId});

  var activeIndex = 0.obs;

  final _userService = sl<UserService>();
  final _authService = sl<AuthService>();
  final _postService = sl<PostService>();

  UserModel? get currentUser => _authService.user;

  Rx<UserDetailModel?> user = Rx<UserDetailModel?>(null);

  RxBool isLoading = false.obs;
  RxBool isLoadingFollowUnfollow = false.obs;

  var posts = <PostModel>[].obs;
  var isLoadingPostActivity = false.obs;
  var hasReacheMaxPostActivity = false.obs;
  var pagePostActivity = 0;
  ScrollController postActivityController = ScrollController();

  @override
  void onInit() {
    getDetailUser();
    getPostActivity(refresh: true);
    super.onInit();
  }

  Future<void> refreshData() async {
    await getDetailUser();
    await getPostActivity(refresh: true);
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

  Future<void> getPostActivity({bool refresh = false}) async {
    if (refresh) {
      posts.clear();
      pagePostActivity = 1;
      hasReacheMaxPostActivity.value = false;
    }
    if (isLoadingPostActivity.value || hasReacheMaxPostActivity.value) return;
    isLoadingPostActivity.value = true;
    try {
      PaginatedDataResponse<PostModel> response =
        await _postService.getAll(
          page: pagePostActivity,
          user: userId,
          limit: 5,
          recordActivityOnly: true,
        );

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMaxPostActivity.value = true;

      posts += response.data;

      pagePostActivity++;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingPostActivity.value = false;
    }
  }
}
