import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/model/club_activities_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/widget/confirmation.dart';

class ClubActivityTabController extends GetxController {
  ScrollController clubActivityScrollController = ScrollController();
  final _debouncer = Debouncer(milliseconds: 500);
  RxBool isLoading = false.obs;
  RxBool isLoadingAction = false.obs;
  RxBool hasReacheMax = false.obs;
  final ClubService _clubService = sl<ClubService>();
  var page = 1;
  RxList<ClubActivitiesModel?> activities = <ClubActivitiesModel?>[].obs;
  final _eventService = sl<EventService>();

  var clubId = ''.obs;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is String) {
      clubId.value = Get.arguments as String;
    } else {
      Future.delayed(Duration.zero, () {
        Get.snackbar("Error", "Could not load data");
        if (Get.previousRoute.isNotEmpty) {
          Get.back(closeOverlays: true);
        }
      });
    }
    getClubActivity();
    clubActivityScrollController.addListener(() {
      final position = clubActivityScrollController.position;

      bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;

      _debouncer.run(() {
        if (isNearBottom && !isLoading.value && !hasReacheMax.value) {
          getClubActivity();
        }
      });
    });
  }

  Future<void> getClubActivity() async {
    if (isLoading.value || hasReacheMax.value) return;

    try {
      isLoading.value = true;

      final response =
          await _clubService.getClubActivity(clubId: clubId.value, page: page);

      // Deteksi akhir halaman dengan lebih akurat
      if ((response.pagination.next == null ||
              response.pagination.next!.isEmpty) ||
          response.data.isEmpty ||
          response.data.length < 20) {
        hasReacheMax.value = true;
      }

      // Tambahkan hasil ke list
      activities.addAll(response.data);

      // Increment page terakhir
      page++;
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelEvent(String id) async {
    isLoadingAction.value = true;
    try {
      final EventModel? res = await _eventService.cancelEvent(id);

      if (res != null) {
        // cari index item yang punya event dengan id yang dicancel
        int index =
            activities.indexWhere((activity) => activity?.event?.id == id);

        if (index != -1) {
          final oldActivity = activities[index]!;
          final updatedEvent = oldActivity.event!.copyWith(
            cancelledAt: DateTime.now(),
          );
          final updatedActivity = oldActivity.copyWith(event: updatedEvent);

          activities[index] = updatedActivity;
        }

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

  Future<void> syncEvent(EventModel event) async {
    // cari index item yang punya event dengan id yang dicancel
    int index =
        activities.indexWhere((activity) => activity?.event?.id == event.id);

    if (index != -1) {
      final oldActivity = activities[index]!;

      final updatedActivity = oldActivity.copyWith(event: event);

      activities[index] = updatedActivity;
    }
  }

  Future<void> syncChallange(Challange challange) async {
    // cari index item yang punya event dengan id yang dicancel
    int index = activities
        .indexWhere((activity) => activity?.challange?.id == challange.id);

    if (index != -1) {
      final oldActivity = activities[index]!;

      final updatedActivity = oldActivity.copyWith(challange: challange);

      activities[index] = updatedActivity;
    }
  }

  Future<void> syncActivityClubEvent(EventModel newEvent) async {
    final newActivity = ClubActivitiesModel(
      clubId: clubId.value,
      activityableId: newEvent.id, // bisa pakai event id
      activityableType: 'event', // atau apapun yang sesuai API
      createdAt: DateTime.now(),
      challange: null,
      event: newEvent,
    );

    activities.insert(0, newActivity);
  }

  Future<void> syncActivityClubChallange(Challange newChallange) async {
    final newActivity = ClubActivitiesModel(
      clubId: clubId.value,
      activityableId: newChallange.id, // bisa pakai event id
      activityableType: 'challenge', // atau apapun yang sesuai API
      createdAt: DateTime.now(),
      challange: newChallange,
      event: null,
    );

    activities.insert(0, newActivity);
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

  Future<void> accLeaveJoinEvent(String id, {String? leave}) async {
    isLoadingAction.value = true;
    try {
      EventUserModel? res =
          await _eventService.accLeaveJoinEvent(id, leave: leave);

      int index =
          activities.indexWhere((activity) => activity?.event?.id == id);
      if (index != -1) {
        final oldActivity = activities[index]!;

        final updateEvent = oldActivity.event!.copyWith(
          isJoined: res != null ? 1 : 0,
          userOnEventsCount: res != null && (res.status == 1 || res.status == 3)
              ? (oldActivity.event!.userOnEventsCount ?? 0) + 1
              : null,
          userOnEvents: res != null &&
                  res.status == 1 &&
                  (oldActivity.event!.userOnEventsCount ?? 0) < 3
              ? [res, ...oldActivity.event!.userOnEvents ?? []]
              : null,
        );

        final updatedActivity = oldActivity.copyWith(event: updateEvent);
        activities[index] = updatedActivity;

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
}
