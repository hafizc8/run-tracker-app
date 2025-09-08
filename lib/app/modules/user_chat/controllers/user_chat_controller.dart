import 'dart:async';
import 'package:collection/collection.dart';
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
  final scrollController = ScrollController(
    initialScrollOffset: double.maxFinite,
  );

  DateTime? lastMessageTime;

  @override
  void onInit() {
    super.onInit();
    userMini = Get.arguments;
    getChat(initialLoad: true);
    startChat();
    scrollController.addListener(() {
      // Scroll ke atas untuk load older messages
      if (scrollController.position.pixels <= 50) {
        final beforeMaxExtent = scrollController.position.maxScrollExtent;
        if (!isLoading.value && !hasReacheMax.value) {
          loadOlderChats().then((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final afterMaxExtent = scrollController.position.maxScrollExtent;
              final offset = scrollController.position.pixels +
                  (afterMaxExtent - beforeMaxExtent);
              scrollController.jumpTo(offset);
            });
          });
        }
      }
    });
  }

  void startChat() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      getNewChat();
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    messageController.dispose();
    chats.clear();
    super.onClose();
  }

  Future<void> loadOlderChats() async {
    if (isLoading.value || hasReacheMax.value) return;
    isLoading.value = true;
    try {
      PaginatedDataResponse<ChatModel> response = await _userService.getChats(
        page: page,
        userId: userMini?.id ?? '',
      );

      if ((response.pagination.next == null ||
              response.pagination.next!.isEmpty) ||
          response.pagination.total < 20) {
        hasReacheMax.value = true;
      }

      chats.insertAll(0, response.data); // prepend older messages
      page++;
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getChat({bool initialLoad = false}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      PaginatedDataResponse<ChatModel> response = await _userService.getChats(
        page: page,
        userId: userMini?.id ?? '',
      );

      if (response.data.isNotEmpty) {
        lastMessageTime = response.data.first.createdAt;
      }

      chats.insertAll(0, response.data);

      if (initialLoad) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }

      page++;
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getNewChat() async {
    if (isLoading.value || chats.isEmpty) return;
    isLoading.value = true;
    try {
      PaginatedDataResponse<ChatModel> response = await _userService.getChats(
        date: lastMessageTime,
        userId: userMini?.id ?? '',
      );

      if (response.data.isNotEmpty) {
        chats.addAll(response.data);
        lastMessageTime = response.data.first.createdAt;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> storeChat() async {
    if (isLoadingStore.value) return;
    isLoadingStore.value = true;
    try {
      final String messageBody = messageController.text;
      messageController.clear();
      
      ChatModel? response = await _userService.storeChat(
        userId: userMini?.id ?? '',
        message: messageBody,
      );
      if (response != null) {
        messageController.clear();
        message.value = '';
        _timer?.cancel();
        lastMessageTime = response.createdAt;
        chats.add(response); // newest di bawah
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
        if (!(_timer?.isActive ?? false)) {
          startChat();
        }
      }
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingStore.value = false;
    }
  }

  Map<DateTime, List<ChatModel>> get groupedMessages {
    // Urutkan oldest → newest
    var sorted = [...chats]
      ..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

    // Group by hanya tanggal (tanpa jam)
    return groupBy(
      sorted,
      (ChatModel msg) => DateTime(
        msg.createdAt!.year,
        msg.createdAt!.month,
        msg.createdAt!.day,
      ),
    );
  }
}
