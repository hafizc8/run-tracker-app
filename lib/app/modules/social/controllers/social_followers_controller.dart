import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';

class SocialFollowersController extends GetxController {
  var isLoading = false.obs;
  var hasReacheMax = false.obs;
  var resultSearchEmpty = false.obs;
  TextEditingController searchController = TextEditingController();
  final _userService = sl<UserService>();

  var friends = <UserMiniModel>[].obs;
  var search = ''.obs;

  final scrollFriendsController = ScrollController();

  var pageFriend = 1;
  var total = 0.obs;

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    scrollFriendsController.addListener(() {
      var maxScroll = scrollFriendsController.position.pixels >=
          scrollFriendsController.position.maxScrollExtent - 200;

      if (maxScroll && !hasReacheMax.value) {
        load();
      }
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

    _debouncer.run(() => searchFriends(input));
  }

  Future<void> searchFriends(String input) async {
    if (input.isEmpty) {
      friends.clear();
      pageFriend = 1;
      hasReacheMax.value = false;
      return;
    }

    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    resultSearchEmpty.value = false;
    try {
      PaginatedDataResponse<UserMiniModel> response =
          await _userService.getUserList(
        page: pageFriend,
        search: input,
        followStatus: 'followers',
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
        followStatus: 'followers',
      );

      pageFriend++;

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMax.value = true;

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
}
