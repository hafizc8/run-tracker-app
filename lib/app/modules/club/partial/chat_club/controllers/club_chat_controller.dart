import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/models/interface/pagination_response_model.dart';
import 'package:zest_mobile/app/core/models/model/chat_model_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';

class ClubChatController extends GetxController {
  final chats = <ChatModel>[].obs;
  final _clubService = sl<ClubService>();
  final _authService = sl<AuthService>();
  UserModel get user => _authService.user!;

  TextEditingController messageController = TextEditingController();
  var message = ''.obs;
  var id = "".obs;
  var title = "".obs;
  var imgUrl = "".obs;
  int page = 1;
  var hasReacheMax = false.obs;
  var isLoading = false.obs;
  var isLoadingStore = false.obs;

  Timer? _timer;
  DateTime? lastMessageTime;

  final scrollController = ScrollController(
    initialScrollOffset: double.maxFinite,
  );

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments == null) return;

    id.value = Get.arguments['id'] as String;
    title.value = Get.arguments['title'] as String;
    imgUrl.value = Get.arguments['imgUrl'] as String;
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
      PaginatedDataResponse<ChatModel> response =
          await _clubService.getClubChat(
        page: page,
        clubId: id.value,
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
      PaginatedDataResponse<ChatModel> response =
          await _clubService.getClubChat(
        page: page,
        clubId: id.value,
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
    if (chats.isEmpty) return;

    try {
      PaginatedDataResponse<ChatModel> response =
          await _clubService.getClubChat(
        clubId: id.value,
        date: lastMessageTime,
      );

      if (response.data.isNotEmpty) {
        lastMessageTime = response.data.first.createdAt;
        chats.addAll(response.data);
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
    }
  }

  Future<void> storeChat() async {
    isLoadingStore.value = true;
    try {
      ChatModel? response = await _clubService.storeClubChat(
          clubId: id.value, message: messageController.text);
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
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingStore.value = false;
    }
  }

  Map<DateTime, List<ChatModel>> get groupedMessages {
    // oldest → newest
    var sorted = [...chats]
      ..sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

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
