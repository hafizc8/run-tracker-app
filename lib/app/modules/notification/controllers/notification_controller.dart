import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/enums/notification_type_enum.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/notification_model.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/services/post_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/core/shared/widgets/simple_custom_dialog.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart'; // Ganti dengan path model Anda

class NotificationController extends GetxController {

  final _userService = sl<UserService>();
  final _postService = sl<PostService>();
  var notifications = <NotificationModel>[].obs;

  RxInt notificationCount = 0.obs;
  
  var isLoading = false.obs;
  var hasReacheMaxNotification = false.obs;
  var pageNotification = 1;

  ScrollController notificationScrollController = ScrollController();

  var isLoadingReadAll = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetchNotifications();
    notificationScrollController.addListener(() {
      var maxScroll = notificationScrollController.position.pixels >= notificationScrollController.position.maxScrollExtent - 200;

      if (maxScroll && !hasReacheMaxNotification.value) {
        fetchNotifications();
      }
    });
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      print('refresh notification');
      notifications.clear();
      pageNotification = 1;
      hasReacheMaxNotification.value = false;
    }
    if (isLoading.value || hasReacheMaxNotification.value) return;
    isLoading.value = true;
    try {
      PaginatedDataResponse<NotificationModel> response = await _userService.getNotification(
        page: pageNotification,
        limit: 15,
      );

      pageNotification++;

      if ((response.pagination.next == null || response.pagination.next == '') || response.pagination.total < 15) {
        hasReacheMaxNotification.value = true;
      }

      notifications.value += response.data;

      notificationCount.value = response.pagination.total;

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

  void followBack(String userId) async {
    try {
      bool res = await _userService.followUser(userId);

      if (res) {
        // refresh notification
        fetchNotifications(refresh: true);
        // show success snackbar, toast, etc
        Get.snackbar('Success', 'Successfully follow back');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // read notification single or all
  void readNotification({NotificationModel? notification}) async {
    try {
      if (notification?.id != null) {
        if (notification?.readAt != null) {
          showNotificationDetail(notification);
          return;
        }

        bool response = await _userService.readNotification(notificationId: notification?.id);

        if (response) {
          // set single notification to read by id
          notifications.value = notifications.map((e) {
            if (e.id == notification?.id) {
              return e.copyWith(readAt: DateTime.now());
            }

            return e;
          }).toList();

          // action notification by type
          showNotificationDetail(notification);
        }
      } else {
        isLoadingReadAll.value = true;
        bool response = await _userService.readNotification();

        if (response) {
          // refresh notification
          fetchNotifications(refresh: true);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingReadAll.value = false;
    }
  }

  void showNotificationDetail(NotificationModel? notification) {
    if (notification?.type == NotificationTypeEnum.welcomeRegisteredUser.name) {
      // show get dialog
      Get.dialog(
        SimpleCustomDialog(
          title: notification?.data?['title'],
          description: notification?.data?['content'],
        ),
      );

    } else if (notification?.type == NotificationTypeEnum.userFollowing.name) {
      Get.toNamed(AppRoutes.profileUser, arguments: notification?.data?['user']['id']);
    
    } else if (notification?.type == NotificationTypeEnum.clubInvite.name) {
      Get.toNamed(AppRoutes.previewClub, arguments: notification?.data?['club']['id']);
    
    } else if (notification?.type == NotificationTypeEnum.challangeInvite.name) {
      Get.toNamed(AppRoutes.challengedetails, arguments: {"challengeId": notification?.data?['challange']['id']});
    
    } else if (notification?.type == NotificationTypeEnum.eventInvite.name) {
      Get.put(EventController());
      Get.put(EventActionController());
      Get.toNamed(AppRoutes.socialYourPageEventDetail, arguments: {'eventId': notification?.data?['event']['id']});
    
    } else if (notification?.type == NotificationTypeEnum.postComment.name || notification?.type == NotificationTypeEnum.postLike.name) {
      goToDetailPost(postId: notification?.data?['post']['id']);
    }
  }

  void goToDetailPost({required String postId}) async {
    final postController = Get.find<PostController>();

    final PostModel post = await _postService.getDetail(postId: postId);

    postController.postDetail.value = post;

    postController.goToDetail(postId: post.id!);
  }
}