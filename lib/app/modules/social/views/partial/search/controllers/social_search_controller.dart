import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';

import 'dart:async';

import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';

class SocialSearchController extends GetxController {
  var isLoadingPeopleYouMayKnow = false.obs;
  var isLoadingFriends = false.obs;
  var hasReacheMax = false.obs;
  var resultSearchEmpty = false.obs;

  final _userService = sl<UserService>();

  var friendsPeopleYouMayKnow = <UserMiniModel>[].obs;
  var friends = <UserMiniModel>[].obs;
  var search = ''.obs;

  final scrollFriendsController = ScrollController();

  var pageFriend = 1;

  final _debouncer = Debouncer(milliseconds: 400);

  void onSearchChanged(String input) {
    if (search.value != input) {
      friends.clear();
      pageFriend = 1;
      hasReacheMax.value = false;
    }
    search.value = input;

    _debouncer.run(() => searchFriends(input));
  }

  @override
  void onInit() {
    super.onInit();
    searchPeopleYouMayKnow();
  }

  @override
  void onClose() {
    scrollFriendsController.dispose();
    _debouncer.dispose();
    super.onClose();
  }

  Future<void> searchPeopleYouMayKnow() async {
    isLoadingPeopleYouMayKnow.value = true;
    try {
      PaginatedDataResponse<UserMiniModel> response =
          await _userService.getUserList(
        page: 1,
      );
      List<UserMiniModel> users = response.data;
      if (response.data.length > 10) {
        users = response.data.sublist(0, 10);
      }

      friendsPeopleYouMayKnow.value = users;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingPeopleYouMayKnow.value = false;
    }
  }

  Future<void> searchFriends(String input) async {
    if (input.isEmpty) {
      friends.clear();
      pageFriend = 1;
      hasReacheMax.value = false;
      return;
    }

    if (isLoadingFriends.value || hasReacheMax.value) return;
    isLoadingFriends.value = true;
    resultSearchEmpty.value = false;
    try {
      PaginatedDataResponse<UserMiniModel> response =
          await _userService.getUserList(
        page: pageFriend,
        search: input,
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
      isLoadingFriends.value = false;
    }
  }
}
