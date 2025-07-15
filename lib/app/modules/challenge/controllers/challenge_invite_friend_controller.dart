import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';

class ChallengeInviteController extends GetxController {
  var isLoadingFriend = false.obs;
  var isLoadingInviteFriend = false.obs;
  var isLoadingReserveFriend = false.obs;
  var hasReacheMaxFriend = false.obs;
  final _eventService = sl<EventService>();
  final _userService = sl<UserService>();

  var friends = <UserMiniModel>[].obs;
  var invites = <UserMiniModel>[].obs;

  final scrollControllerFriend = ScrollController();

  var page = 1;
  var pageFriend = 1;

  final _debouncer = Debouncer(milliseconds: 500);

  // Search
  var search = ''.obs;
  var resultSearchEmpty = false.obs;

  var eventId = '';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      eventId = Get.arguments['eventId'];
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

      friends.value += response.data;
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

      friends.value += response.data;
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

  Future<void> inviteEvent({bool? isReserved}) async {
    isLoadingInviteFriend.value = true;
    try {
      bool isSuccess = await _eventService.inviteOrReserveEvent(
        eventId,
        isReserved: isReserved,
        userIds: invites.map((e) => e.id).toList(),
      );

      if (isSuccess) {
        Get.back(result: true);
      }
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingInviteFriend.value = false;
    }
  }
}
