import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/chat_model_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';

class UserChatController extends GetxController {
  final chats = <ChatModel>[].obs;
  final _userService = sl<UserService>();
  final _authService = sl<AuthService>();
  UserModel get user => _authService.user!;
  TextEditingController messageController = TextEditingController();
  var message = ''.obs;

  UserMiniModel? userMini;
  int page = 1;
  var hasReacheMax = false.obs;
  var isLoading = false.obs;
  var isLoadingStore = false.obs;

  Timer? _timer;

  final scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    userMini = Get.arguments;
    getChat();
    scrollController.addListener(() {
      final position = scrollController.position;

      bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;
      if (isNearBottom && !isLoading.value && !hasReacheMax.value) {
        startChat();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    userMini = null;
    page = 1;
    hasReacheMax.value = false;
    isLoading.value = false;
    _timer?.cancel();
    messageController.clear();
  }

  void startChat() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) => getChat());
  }

  Future<void> getChat() async {
    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    try {
      PaginatedDataResponse<ChatModel> response =
          await _userService.getChats(page: page, userId: userMini?.id ?? '');

      if ((response.pagination.next == null ||
              response.pagination.next == '') ||
          response.pagination.total < 20) hasReacheMax.value = true;

      chats.value += response.data;

      page++;
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> storeChat() async {
    isLoadingStore.value = true;
    try {
      ChatModel? response = await _userService.storeChat(
          userId: userMini?.id ?? '', message: messageController.text);
      if (response != null) {
        messageController.clear();
        chats.add(response);
      }
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingStore.value = false;
    }
  }
}
