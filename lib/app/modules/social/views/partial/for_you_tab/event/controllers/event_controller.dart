import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';

class EventController extends GetxController {
  var isLoading = false.obs;
  var hasReacheMax = false.obs;
  final _eventService = sl<EventService>();

  var events = <EventModel>[].obs;

  final scrollController = ScrollController();

  var page = 1;

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
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
          await _eventService.getEvents(page: page);

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
}
