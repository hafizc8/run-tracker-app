import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/chat_model_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';

class EventChatController extends GetxController {
  final _eventService = sl<EventService>();
  final _authService = sl<AuthService>();

  TextEditingController messageController = TextEditingController();

  UserModel get user => _authService.user!;
  var chats = <ChatModel>[].obs;
  var id = "".obs;
  int page = 1;
  var hasReacheMax = false.obs;
  var isLoading = false.obs;
  var isLoadingStore = false.obs;

  Timer? _timer;

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments == null) return;
    id.value = Get.arguments as String;
    startChat();
    scrollController.addListener(() {
      final position = scrollController.position;

      bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;
      if (isNearBottom && !isLoading.value && !hasReacheMax.value) {
        startChat();
      }
    });
  }

  void startChat() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) => getChat());
  }

  @override
  void onClose() {
    super.onClose();
    id.value = "";
    page = 1;
    hasReacheMax.value = false;
    isLoading.value = false;
    _timer?.cancel();
    messageController.clear();
  }

  Future<void> getChat() async {
    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    try {
      PaginatedDataResponse<ChatModel> response =
          await _eventService.getEventChat(page: page, eventId: id.value);

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
      print('id event: ${id.value}');
      ChatModel? response = await _eventService.storeEventChat(
          eventId: id.value, message: messageController.text);
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
