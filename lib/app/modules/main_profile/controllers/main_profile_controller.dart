import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/challenge_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/models/model/user_detail_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/challenge_service.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/modules/main_profile/widgets/custom_tab_bar/controllers/custom_tab_bar_controller.dart';

class ProfileMainController extends GetxController {
  var activeIndex = 0.obs;
  var pageEvent = 0;
  var isLoadingEvent = false.obs;
  var isLoadingActionEvent = false.obs;
  var isLoadingUpComingEvent = false.obs;
  var hasReacheMaxEvent = false.obs;
  ScrollController eventController = ScrollController();

  var isLoadingChallenge = false.obs;
  var hasReacheMaxChallenge = false.obs;
  var pageChallenge = 0;
  ScrollController challengeController = ScrollController();

  final _authService = sl<AuthService>();
  final _userService = sl<UserService>();
  final _eventService = sl<EventService>();
  final _challengeService = sl<ChallengeService>();

  final TabBarController tabBarController = Get.put(TabBarController());

  Rx<UserDetailModel?> user = Rx<UserDetailModel?>(null);
  var events = <EventModel>[].obs;
  var upComingEvents = <EventModel>[].obs;
  var challenges = <ChallengeModel>[].obs;

  @override
  void onInit() {
    init();
    eventController.addListener(() {
      var maxScroll = eventController.position.pixels >=
          eventController.position.maxScrollExtent - 200;

      if (maxScroll && !hasReacheMaxEvent.value) {
        getEvents();
      }
    });
    super.onInit();
  }

  Future<void> getDetailUser() async {
    try {
      user.value = await _userService.detailUser(_authService.user!.id!);
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
    }
  }

  Future<void> cancelEvent(String id) async {
    isLoadingActionEvent.value = true;
    try {
      final EventModel? res = await _eventService.cancelEvent(id);
      int index = events.indexWhere((element) => element.id == id);
      if (index != -1) {
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
      isLoadingActionEvent.value = false;
    }
  }

  Future<void> getEvents({bool refresh = false}) async {
    getUpComingEvents();
    if (refresh) {
      events.clear();
      pageEvent = 1;
      hasReacheMaxEvent.value = false;
    }
    if (isLoadingEvent.value || hasReacheMaxEvent.value) return;
    isLoadingEvent.value = true;
    try {
      PaginatedDataResponse<EventModel> response =
          await _eventService.getEvents(
        page: pageEvent,
        user: _authService.user!.id,
        limit: 10,
      );

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMaxEvent.value = true;

      events.value += response.data;

      pageEvent++;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingEvent.value = false;
    }
  }

  Future<void> getUpComingEvents() async {
    isLoadingUpComingEvent.value = true;
    try {
      PaginatedDataResponse<EventModel> response =
          await _eventService.getEvents(
        page: pageEvent,
        user: _authService.user!.id,
        startDate: DateFormat('yyyy-MM-dd').format(
          DateTime.now().add(
            const Duration(days: 1),
          ),
        ),
        limit: 3,
        order: 'upcoming',
      );

      upComingEvents.value = response.data;

      pageEvent++;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingUpComingEvent.value = false;
    }
  }

  Future<void> getChallenges({bool refresh = false}) async {
    if (refresh) {
      challenges.clear();
      pageChallenge = 1;
      hasReacheMaxChallenge.value = false;
    }
    if (isLoadingChallenge.value || hasReacheMaxChallenge.value) return;
    isLoadingChallenge.value = true;
    try {
      PaginatedDataResponse<ChallengeModel> response =
          await _challengeService.getChallenges(
        page: pageChallenge,
        status: 'joined',
        limit: 10,
      );

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMaxChallenge.value = true;

      challenges.value += response.data;

      pageChallenge++;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingChallenge.value = false;
    }
  }

  Future<void> init() async {
    Future.wait([
      getDetailUser(),
      getEvents(refresh: true),
      getChallenges(refresh: true),
    ]);
  }
}
