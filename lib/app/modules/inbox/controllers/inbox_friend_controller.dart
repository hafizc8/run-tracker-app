import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/chat_inbox_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class InboxFriendController extends GetxController {
  final chats = <ChatInboxModel>[].obs;
  final _userService = sl<UserService>();
  final _authService = sl<AuthService>();
  UserModel get user => _authService.user!;

  int page = 1;
  var hasReacheMax = false.obs;
  var isLoading = false.obs;

  final scrollController = ScrollController();

  final _debouncer = Debouncer();
  @override
  void onInit() {
    super.onInit();
    getChat(refresh: true);
    scrollController.addListener(() {
      final position = scrollController.position;

      bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;
      _debouncer.run(() {
        if (isNearBottom && !isLoading.value && !hasReacheMax.value) {
          getChat();
        }
      });
    });
  }

  Future<void> getChat({bool refresh = false}) async {
    if (refresh) {
      chats.clear();
      page = 1;
      hasReacheMax.value = false;
    }
    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    try {
      PaginatedDataResponse<ChatInboxModel> response =
          await _userService.getInboxChats(
        page: page,
        relatedType: 'user',
      );

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMax.value = true;

      chats.addAll(response.data);

      page++;
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void refreshFriend() {
    getChat(refresh: true);
  }

  void goToRoomChatFriend(ChatInboxModel chat) {
    Get.toNamed(
      AppRoutes.userChat,
      arguments: UserMiniModel(
        id: chat.relateableUser?.id ?? '',
        name: chat.relateableUser?.name ?? '',
        imageUrl: chat.relateableUser?.imageUrl ?? '',
      ),
    );
  }
}
