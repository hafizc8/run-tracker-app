import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';

class SocialInfoFollowersController extends GetxController {
  var isLoading = false.obs;
  var hasReacheMax = false.obs;
  var resultSearchEmpty = false.obs;
  var isLoadingFollow = false.obs;
  var userId = ''.obs;

  TextEditingController searchController = TextEditingController();

  final _userService = sl<UserService>();
  final _authService = sl<AuthService>();

  UserModel? get user => _authService.user;

  var friends = <UserMiniModel>[].obs;
  var search = ''.obs;

  final scrollFriendsController = ScrollController();

  var pageFriend = 1;
  var total = 0.obs;

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    userId.value = '';
    if (Get.arguments != null) {
      if (Get.arguments['id'] != null) {
        userId.value = Get.arguments['id'];
      }
    }
    load(refresh: true);
    scrollFriendsController.addListener(() {
      final position = scrollFriendsController.position;

      bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;

      _debouncer.run(() {
        if (isNearBottom && !isLoading.value && !hasReacheMax.value) {
          load();
        }
      });
    });
  }

  @override
  void onClose() {
    scrollFriendsController.dispose();
    _debouncer.dispose();
    super.onClose();
  }

  void onSearchChanged(String input) {
    if (search.value != input) {
      friends.clear();
      pageFriend = 1;
      hasReacheMax.value = false;
    }
    search.value = input;
    searchController.text = input;
    _debouncer.run(() => searchFriends(input));
  }

  Future<void> searchFriends(String input) async {
    if (input.isEmpty) {
      friends.clear();
      pageFriend = 1;
      hasReacheMax.value = false;
    }

    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    resultSearchEmpty.value = false;
    try {
      PaginatedDataResponse<UserMiniModel> response =
          await _userService.getUserList(
        page: pageFriend,
        random: 0,
        search: input,
        followersBy: userId.value,
      );

      pageFriend++;

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMax.value = true;

      if (response.data.isEmpty) {
        resultSearchEmpty.value = true;
      } else {
        friends.value += response.data;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> load({bool refresh = false}) async {
    if (refresh) {
      friends.clear();
      pageFriend = 1;
      hasReacheMax.value = false;
      search.value = '';
      searchController.text = '';
    }
    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    try {
      PaginatedDataResponse<UserMiniModel> response =
          await _userService.getUserList(
        page: pageFriend,
        random: 0,
        followersBy: userId.value,
      );

      pageFriend++;

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMax.value = true;
      total.value = response.pagination.total;
      friends.value += response.data;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> follow(String id) async {
    userId.value = id;
    isLoadingFollow.value = true;
    try {
      bool res = await _userService.followUser(id);

      if (res) {
        int index = friends.indexWhere((element) => element.id == id);
        if (index != -1) {
          final user = friends[index];
          friends[index] = user.copyWith(
            isFollowing: res ? 1 : 0,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      userId.value = '';
      isLoadingFollow.value = false;
    }
  }

  Future<void> unFollow(String id) async {
    userId.value = id;
    isLoadingFollow.value = true;
    try {
      bool res = await _userService.unFollowUser(id);

      if (res) {
        int index = friends.indexWhere((element) => element.id == id);
        if (index != -1) {
          final user = friends[index];
          friends[index] = user.copyWith(
            isFollowing: res ? 0 : 1,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      userId.value = '';
      isLoadingFollow.value = false;
    }
  }
}
