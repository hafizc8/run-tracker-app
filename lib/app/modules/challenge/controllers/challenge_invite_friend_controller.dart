import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';

class ChallengeInviteController extends GetxController {
  var isLoadingFriend = false.obs;
  var isLoadingInviteFriend = false.obs;
  var isLoadingReserveFriend = false.obs;
  var hasReacheMaxFriend = false.obs;

  final _userService = sl<UserService>();

  var friends = <UserMiniModel>[].obs;
  var invites = <UserMiniModel>[].obs;

  final scrollControllerFriend = ScrollController();

  var page = 1;
  var pageFriend = 1;

  final _debouncer = Debouncer(milliseconds: 500);

  var ids = <String?>[].obs;

  // Search
  var search = ''.obs;
  var resultSearchEmpty = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['ids'] != null) {
      ids.value = Get.arguments['ids'];
    }
    loadFriends();
    debounce(
      search,
      (callback) {
        searchFriends(callback);
      },
      time: const Duration(milliseconds: 500),
    );

    scrollControllerFriend.addListener(() {
      var maxScroll = scrollControllerFriend.position.pixels >=
          scrollControllerFriend.position.maxScrollExtent - 200;

      if (maxScroll && !hasReacheMaxFriend.value) {
        loadFriends();
      }
    });
  }

  @override
  void onClose() {
    scrollControllerFriend.dispose();
    _debouncer.dispose();
    super.onClose();
  }

  Future<void> searchFriends(String input) async {
    resultSearchEmpty.value = false;
    friends.clear();
    pageFriend = 1;
    hasReacheMaxFriend.value = false;

    if (isLoadingFriend.value || hasReacheMaxFriend.value) return;
    isLoadingFriend.value = true;
    try {
      PaginatedDataResponse<UserMiniModel> response =
          await _userService.getUserList(
        page: pageFriend,
        followStatus: 'followers',
        search: input,
      );

      if (response.data.isEmpty) {
        resultSearchEmpty.value = true;
      }

      pageFriend++;

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMaxFriend.value = true;

      friends.value +=
          response.data.where((element) => !ids.contains(element.id)).toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingFriend.value = false;
    }
  }

  Future<void> loadFriends({bool refresh = false}) async {
    if (refresh) {
      friends.clear();
      pageFriend = 1;
      hasReacheMaxFriend.value = false;
    }
    if (isLoadingFriend.value || hasReacheMaxFriend.value) return;
    isLoadingFriend.value = true;
    try {
      PaginatedDataResponse<UserMiniModel> response =
          await _userService.getUserList(
        page: pageFriend,
        followStatus: 'followers',
      );

      pageFriend++;

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMaxFriend.value = true;

      friends.value +=
          response.data.where((element) => !ids.contains(element.id)).toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingFriend.value = false;
    }
  }

  void toggleInvite(UserMiniModel user) {
    if (invites.contains(user)) {
      invites.remove(user);
    } else {
      invites.add(user);
    }
  }

  void inviteEvent() {
    List<User> result = invites
        .map(
          (e) => User(
            id: e.id,
            name: e.name,
            imagePath: e.imagePath,
            imageUrl: e.imageUrl,
          ),
        )
        .toList();
    Get.back(result: result);
  }
}
