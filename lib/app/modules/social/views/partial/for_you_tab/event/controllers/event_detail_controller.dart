import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';

class EventDetailController extends GetxController {
  var isLoading = false.obs;
  var isLoadingWaitList = false.obs;
  var hasReacheMax = false.obs;
  var hasReacheMaxWaiting = false.obs;

  final _eventService = sl<EventService>();

  var usersInvites = <EventUserModel>[].obs;
  var usersWaitings = <EventUserModel>[].obs;

  var page = 1;
  var eventId = '';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      eventId = Get.arguments['eventId'];
    }
    init();
  }

  Future<void> init() async {
    Future.wait([
      loadGoing(),
      loadWaiting(),
    ]);
  }

  Future<void> loadGoing({bool refresh = false}) async {
    if (refresh) {
      usersInvites.clear();
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
        statues: ['1'],
      );

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMax.value = true;

      usersInvites.value += response.data.length > 10
          ? response.data.sublist(0, 10)
          : response.data;

      page++;
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

  Future<void> loadWaiting({bool refresh = false}) async {
    if (refresh) {
      usersWaitings.clear();
      page = 1;
      hasReacheMaxWaiting.value = false;
    }
    if (isLoadingWaitList.value || hasReacheMaxWaiting.value) return;
    isLoadingWaitList.value = true;
    try {
      PaginatedDataResponse<EventUserModel> response =
          await _eventService.getEventUsers(
        eventId: eventId,
        page: page,
        statues: ['2'],
      );

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMaxWaiting.value = true;

      usersWaitings.value += response.data.length > 10
          ? response.data.sublist(0, 10)
          : response.data;

      page++;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingWaitList.value = false;
    }
  }
}
