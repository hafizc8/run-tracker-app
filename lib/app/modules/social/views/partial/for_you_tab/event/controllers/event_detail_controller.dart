import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';

class EventDetailController extends GetxController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;
  var isLoadingGoing = false.obs;
  var isLoadingWaitList = false.obs;
  var hasReacheMax = false.obs;
  var hasReacheMaxWaiting = false.obs;

  final _eventService = sl<EventService>();

  var usersInvites = <EventUserModel>[].obs;
  var usersWaitings = <EventUserModel>[].obs;
  Rx<EventModel?> event = Rx(null);
  Rx<EventModel?> eventLastUpdated = Rx(null);

  final eventController = Get.find<EventController>();

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

  Future<void> detailEvent() async {
    isLoading.value = true;
    try {
      final EventModel? res = await _eventService.detailEvent(eventId);
      if (res == null) return;
      event.value = res.copyWith(
        userOnEvents: usersInvites,
      );
      eventLastUpdated.value = event.value;
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
      isLoading.value = false;
    }
  }

  Future<void> accLeaveJoinEvent(String id, {String? leave}) async {
    isLoadingAction.value = true;
    try {
      final bool res = await _eventService.accLeaveJoinEvent(id, leave: leave);

      if (res) {
        await refreshUsersOnEvent();

        event.value = event.value!.copyWith(
          isJoined: leave != null ? 0 : 1,
        );
        eventLastUpdated.value = event.value?.copyWith(
          userOnEvents: usersInvites,
          isJoined: leave != null ? 0 : 1,
          userOnEventsCount: usersInvites.length,
        );
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
      isLoadingAction.value = false;
    }
  }

  Future<void> init() async {
    Future.wait([
      detailEvent(),
      loadGoing(refresh: true),
      loadWaiting(refresh: true),
    ]);
  }

  Future<void> refreshUsersOnEvent() async {
    Future.wait([
      loadGoing(refresh: true),
      loadWaiting(refresh: true),
    ]);
  }

  Future<void> loadGoing({bool refresh = false}) async {
    if (refresh) {
      usersInvites.clear();
      page = 1;
      hasReacheMax.value = false;
    }
    if (isLoadingGoing.value || hasReacheMax.value) return;
    isLoadingGoing.value = true;
    try {
      PaginatedDataResponse<EventUserModel> response =
          await _eventService.getEventUsers(
        eventId: eventId,
        page: page,
        statues: ['1', '3'],
      );

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMax.value = true;

      usersInvites.value += response.data;
      usersInvites.refresh();

      page++;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingGoing.value = false;
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

      usersWaitings.value += response.data;

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
