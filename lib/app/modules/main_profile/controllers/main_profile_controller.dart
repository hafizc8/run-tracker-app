import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/challenge_model.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/models/model/user_detail_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/challenge_service.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';
import 'package:zest_mobile/app/core/services/post_service.dart';
import 'package:zest_mobile/app/core/services/storage_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/unit_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_dialog_confirmation.dart';
import 'package:zest_mobile/app/core/values/storage_keys.dart';
import 'package:zest_mobile/app/modules/main_profile/widgets/custom_tab_bar/controllers/custom_tab_bar_controller.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/widget/confirmation.dart';

class ProfileMainController extends GetxController {
  var activeIndex = 0.obs;
  var pageEvent = 0;
  var isLoadingEvent = false.obs;
  var isLoadingActionEvent = false.obs;
  var isLoadingUser = false.obs;
  var hasReacheMaxEvent = false.obs;
  ScrollController eventController = ScrollController();

  var isLoadingChallenge = false.obs;
  var hasReacheMaxChallenge = false.obs;
  var pageChallenge = 0;
  ScrollController challengeController = ScrollController();

  var isLoadingPostActivity = false.obs;
  var hasReacheMaxPostActivity = false.obs;
  var pagePostActivity = 0;
  ScrollController postActivityController = ScrollController();

  final _authService = sl<AuthService>();
  final _userService = sl<UserService>();
  final _eventService = sl<EventService>();
  final _challengeService = sl<ChallengeService>();
  final _postService = sl<PostService>();
  final unitHelper = sl<UnitHelper>();

  final TabBarController tabBarController = Get.put(TabBarController());

  Rx<UserDetailModel?> user = Rx<UserDetailModel?>(null);
  var posts = <PostModel>[].obs;
  var events = <EventModel>[].obs;
  var upComingEvents = <EventModel>[].obs;
  var challenges = <ChallengeModel>[].obs;

  UserModel? get userMe => _authService.user;

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
    isLoadingUser.value = true;
    try {
      final storedUser = sl<StorageService>().read(StorageKeys.detailUser);

      if (storedUser != null) {
        // Load from local storage
        user.value = UserDetailModel.fromJson(storedUser);
      } else {
        // Fetch from server
        user.value = await _userService.detailUser(_authService.user!.id!);
        await sl<StorageService>()
            .write(StorageKeys.detailUser, user.value!.toJson());
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
      isLoadingUser.value = false;
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

  Future<void> confirmCancelEvent(String id) async {
    await Get.dialog(
      Obx(
        () => ConfirmationDialog(
          onConfirm: () => cancelEvent(id),
          title: 'Cancelling?',
          subtitle:
              'If you need to leave an event after joining, please message the host to explain. It keeps things respectful and helps with planning.',
          labelConfirm: 'Leave Event',
          isLoading: isLoadingActionEvent.value,
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
          isLoading: isLoadingActionEvent.value,
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
          isLoading: isLoadingActionEvent.value,
        ),
      ),
    );
  }

  Future<void> accLeaveJoinEvent(String id, {String? leave}) async {
    isLoadingActionEvent.value = true;
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
          events[index] = event.copyWith(
            isJoined: 0,
            userOnEventsCount: (events[index].userOnEventsCount ?? 0) - 1,
          );
          return;
        }

        events[index] = event.copyWith(
          isJoined: res != null ? 1 : 0,
          userOnEventsCount: res != null && (res.status == 1 || res.status == 3)
              ? (events[index].userOnEventsCount ?? 0) + 1
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
      isLoadingActionEvent.value = false;
    }
  }

  String formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}';

  String formatTimeOfDayToHms(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  Future<void> openGoogleMaps(String placeName) async {
    final Uri url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(placeName)}");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak dapat membuka Google Maps';
    }
  }

  Future<void> getEvents({bool refresh = false}) async {
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
        order: 'upcoming',
        status: 'joined',
        completed: '1',
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
        completed: '1',
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

  Future<void> getPostActivity({bool refresh = false}) async {
    if (refresh) {
      posts.clear();
      pagePostActivity = 1;
      hasReacheMaxPostActivity.value = false;
    }
    if (isLoadingPostActivity.value || hasReacheMaxPostActivity.value) return;
    isLoadingPostActivity.value = true;
    try {
      String? userId = _authService.user!.id;
      PaginatedDataResponse<PostModel> response = await _postService.getAll(
        page: pagePostActivity,
        user: userId,
        limit: 5,
        recordActivityOnly: true,
      );

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 5) hasReacheMaxPostActivity.value = true;

      posts.addAll(response.data
          .map((e) => e.copyWith(isOwner: e.user?.id == userId))
          .toList());

      pagePostActivity++;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      ); // show error snackbar, toast, etc (e.g.message)
    } finally {
      isLoadingPostActivity.value = false;
    }
  }

  // go to detail post
  void goToDetailPost({PostModel? post, bool isFocusComment = false}) {
    final postController = Get.find<PostController>();
    postController.postDetail.value = post;

    postController.goToDetail(
        postId: post!.id!, isFocusComment: isFocusComment);
  }

  Future<void> confirmAndDeletePost(
      {required String postId, bool isPostDetail = false}) async {
    Get.dialog(CustomDialogConfirmation(
      title: 'Delete Post',
      subtitle: 'Are you sure to delete this post?',
      labelConfirm: 'Yes, delete',
      onConfirm: () {
        if (isPostDetail) {
          Get.back(closeOverlays: true); // close detail page
        }
        Get.back(closeOverlays: true);
        _deletePost(postId: postId);
      },
      onCancel: () => Get.back(),
    ));
  }

  Future<void> _deletePost({required String postId}) async {
    try {
      bool resp = await _postService.delete(postId: postId);
      if (resp) {
        await getPostActivity(refresh: true);
        Get.snackbar('Success', 'Successfully deleted post');
      }
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> likePost({required String postId, int isDislike = 0}) async {
    try {
      bool resp =
          await _postService.likeDislike(postId: postId, isDislike: isDislike);
      if (resp) {
        // update manual is_liked
        final index = posts.indexWhere((element) => element.id == postId);
        if (index != -1) {
          final updated = posts[index].copyWith(
            isLiked: isDislike == 0,
            likesCount: isDislike == 0
                ? posts[index].likesCount! + 1
                : posts[index].likesCount! - 1,
          );
          posts[index] = updated;
          if (isDislike == 0) {
            posts[index].likes?.add(UserMiniModel(
                id: userMe?.id ?? '',
                name: userMe?.name ?? '',
                imageUrl: userMe?.imageUrl ?? ''));
          } else {
            posts[index]
                .likes
                ?.removeWhere((element) => element.id == userMe?.id);
          }
        }
      }
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> init() async {
    Future.wait([
      getDetailUser(),
      getPostActivity(refresh: true),
      getEvents(refresh: true),
      getChallenges(refresh: true),
    ]);
  }
}
