import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/event_location_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/widget/confirmation.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/widget/filter.dart';

class EventController extends GetxController {
  var isLoading = false.obs;
  var isLoadingAction = false.obs;
  var isLoadingDetail = false.obs;
  var hasReacheMax = false.obs;

  final _eventService = sl<EventService>();

  var events = <EventModel>[].obs;

  Rx<EventModel?> event = Rx(null);
  var eventLocations = <EventLocationModel>[].obs;
  var friends = <UserMiniModel>[].obs;

  final scrollController = ScrollController();

  var page = 1;

  final _debouncer = Debouncer(milliseconds: 500);

  Rx<String?> activity = Rx(null);
  Rx<String?> location = Rx(null);

  PickerDateRange? selectedRange;
  TextEditingController dateController = TextEditingController();
  var isApplyFilter = false.obs;

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
        order: 'upcoming',
        activity: activity.value == 'All' ? null : activity.value,
        startDate: selectedRange?.startDate?.toYyyyMmDdString(),
        endDate: selectedRange?.endDate?.toYyyyMmDdString(),
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
    PickerDateRange? selectedRange;

    PickerDateRange? res = await Get.dialog(
      StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text(
            'Choose Date Range',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 500,
                height: 400,
                child: SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.range,
                  view: DateRangePickerView.month,
                  initialSelectedRange: this.selectedRange,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    if (args.value is PickerDateRange) {
                      selectedRange = args.value;
                      setState(() {});
                    }
                  },
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Get.back();
                  },
                ),
                TextButton(
                  onPressed: selectedRange?.startDate == null
                      ? null
                      : () {
                          Get.back(result: selectedRange);
                        },
                  child: const Text('Save'),
                ),
              ])
            ],
          ),
        );
      }),
    );

    if (res != null) {
      this.selectedRange = res;
      if (res.endDate != null) {
        dateController.text =
            '${res.startDate?.toYyyyMmDdString()} - ${res.endDate?.toYyyyMmDdString()}';
      } else {
        dateController.text = res.startDate?.toYyyyMmDdString() ?? '';
      }
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
      if (res != null) {
        Get.back();
        Get.back();
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

  Future<void> confirmAccLeaveJoinEvent(String id) async {
    await Get.dialog(
      Obx(
        () => ConfirmationDialog(
          onConfirm: () => accLeaveJoinEvent(id),
          title: 'Confirm Joining?',
          subtitle:
              'Events take effort to set up, so if you join, make sure you can be there!',
          labelConfirm: 'Join Event',
          isLoading: isLoadingAction.value,
        ),
      ),
    );
  }

  Future<void> confirmCancelEvent(String id) async {
    await Get.dialog(
      Obx(
        () => ConfirmationDialog(
          onConfirm: () => cancelEvent(id),
          title: 'Cancelling?',
          subtitle:
              'Are you sure you want to cancel this event? The event will be removed from all participants schedules. If possible, let them know the reason—it helps maintain trust and clarity.',
          labelConfirm: 'Cancel Event',
          isLoading: isLoadingAction.value,
        ),
      ),
    );
  }

  Future<void> confirmLeaveEvent(String id) async {
    await Get.dialog(
      Obx(
        () => ConfirmationDialog(
          onConfirm: () => cancelEvent(id),
          title: 'Leaving?',
          subtitle:
              'If you need to leave an event after joining, please message the host to explain. It keeps things respectful and helps with planning.',
          labelConfirm: 'Leave Event',
          isLoading: isLoadingAction.value,
        ),
      ),
    );
  }

  Future<void> accLeaveJoinEvent(String id, {String? leave}) async {
    isLoadingAction.value = true;
    try {
      EventUserModel? res =
          await _eventService.accLeaveJoinEvent(id, leave: leave);
      if (res != null) {
        Get.back();
      }
      int index = events.indexWhere((element) => element.id == id);
      if (index != -1) {
        final event = events[index];
        if (leave != null) {
          if (this.event.value != null) {
            this.event.value = event.copyWith(
              isJoined: 0,
              userOnEventsCount: (event.userOnEventsCount ?? 0) - 1,
            );
          }
          events[index] = event.copyWith(
            isJoined: 0,
            userOnEventsCount: (events[index].userOnEventsCount ?? 0) - 1,
          );
          return;
        }
        if (this.event.value != null) {
          this.event.value = event.copyWith(
            isJoined: res != null ? 1 : 0,
            userOnEventsCount:
                res != null ? (event.userOnEventsCount ?? 0) + 1 : null,
          );
        }
        events[index] = event.copyWith(
          isJoined: res != null ? 1 : 0,
          userOnEventsCount: res != null && (res.status == 1 || res.status == 3)
              ? (events[index].userOnEventsCount ?? 0) + 1
              : null,
          userOnEvents: res != null &&
                  res.status == 1 &&
                  (event.userOnEventsCount ?? 0) < 3
              ? [res, ...event.userOnEvents ?? []]
              : null,
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

  void filter() {
    Get.dialog(FilterDialog());
  }

  void applyFilter() {
    isApplyFilter.value = true;
    Get.back();
    load(refresh: true);
  }

  void resetFilter() {
    isApplyFilter.value = false;
    Get.back();
    activity.value = null;
    location.value = null;
    selectedRange = null;
    dateController.text = '';
    load(refresh: true);
  }

  void resetFormFilter() {
    activity.value = null;
    location.value = null;
    selectedRange = null;
    dateController.text = '';
  }
}
