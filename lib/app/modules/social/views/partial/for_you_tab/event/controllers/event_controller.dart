import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/event_location_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class EventController extends GetxController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;
  var isLoadingDetail = false.obs;
  var hasReacheMax = false.obs;
  final _eventService = sl<EventService>();

  var events = <EventModel>[].obs;
  Rx<EventModel?> event = Rx(null);
  var eventLocations = <EventLocationModel>[].obs;

  final scrollController = ScrollController();

  var page = 1;

  final _debouncer = Debouncer(milliseconds: 500);

  Rx<String?> activity = Rx(null);
  Rx<String?> location = Rx(null);
  DateTimeRange? selectedRange;
  TextEditingController dateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getLocations();
    load();
    scrollController.addListener(() {
      var maxScroll = scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200;

      if (maxScroll && !hasReacheMax.value) {
        load();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    _debouncer.dispose();
    super.onClose();
  }

  Future<void> getLocations() async {
    try {
      eventLocations.value = await _eventService.getEventLocation();
    } on AppException catch (e) {
      eventLocations.value = EventLocationModel.defaultListEventActivity();
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      eventLocations.value = EventLocationModel.defaultListEventActivity();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> load({bool refresh = false}) async {
    if (refresh) {
      events.clear();
      page = 1;
      hasReacheMax.value = false;
    }
    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    try {
      PaginatedDataResponse<EventModel> response =
          await _eventService.getEvents(
        page: page,
        activity: activity.value == 'All' ? null : activity.value,
        startDate: selectedRange?.start.toYyyyMmDdString(),
        endDate: selectedRange?.end.toYyyyMmDdString(),
        location: location.value == 'All' ? null : location.value,
      );

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMax.value = true;

      events.value += response.data;

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

  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: selectedRange,
    );

    if (result != null) {
      selectedRange = result;
      dateController.text =
          '${result.start.toYyyyMmDdString()} - ${result.end.toYyyyMmDdString()}';
      load(refresh: true);
    }
  }

  Future<void> cancelEvent(String id) async {
    isLoadingAction.value = true;
    try {
      final EventModel? res = await _eventService.cancelEvent(id);
      int index = events.indexWhere((element) => element.id == id);
      if (index != -1) {
        if (this.event.value != null) {
          this.event.value = this.event.value!.copyWith(
                cancelledAt: res != null ? DateTime.now() : null,
              );
        }
        final event = events[index];
        events[index] = event.copyWith(
          cancelledAt: res != null ? DateTime.now() : null,
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

  Future<void> detailEvent(String id) async {
    isLoadingDetail.value = true;
    try {
      final EventModel? res = await _eventService.detailEvent(id);
      event.value = res;
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
      isLoadingDetail.value = false;
    }
  }

  Future<void> accLeaveJoinEvent(String id, {String? leave}) async {
    isLoadingAction.value = true;
    try {
      final bool res = await _eventService.accLeaveJoinEvent(id);
      int index = events.indexWhere((element) => element.id == id);
      if (index != -1) {
        final event = events[index];
        if (leave != null) {
          if (this.event.value != null) {
            this.event.value = event.copyWith(
              isJoined: 0,
            );
          }
          events[index] = event.copyWith(
            isJoined: 0,
          );
          return;
        }
        if (this.event.value != null) {
          this.event.value = event.copyWith(
            isJoined: res ? 1 : 0,
          );
        }
        events[index] = event.copyWith(
          isJoined: res ? 1 : 0,
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
}
