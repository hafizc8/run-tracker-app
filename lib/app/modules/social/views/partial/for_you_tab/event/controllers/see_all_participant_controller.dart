import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';

class SeeAllParticipantController extends GetxController {
  var isLoading = false.obs;
  var hasReacheMax = false.obs;
  final _eventService = sl<EventService>();

  var friends = <EventUserModel>[].obs;

  final scrollControllerFriend = ScrollController();

  var page = 1;

  final _debouncer = Debouncer(milliseconds: 500);

  var eventId = '';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      eventId = Get.arguments['eventId'];
    }
    loadFriends();

    scrollControllerFriend.addListener(() {
      var maxScroll = scrollControllerFriend.position.pixels >=
          scrollControllerFriend.position.maxScrollExtent - 200;

      if (maxScroll && !hasReacheMax.value) {
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

  Future<void> loadFriends({bool refresh = false}) async {
    if (refresh) {
      friends.clear();
      page = 1;
      hasReacheMax.value = false;
    }
    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    try {
      PaginatedDataResponse<EventUserModel> response =
          await _eventService.getEventUsers(
        eventId: eventId,
        page: page,
        statues: ['1', '3'],
      );

      page++;

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
