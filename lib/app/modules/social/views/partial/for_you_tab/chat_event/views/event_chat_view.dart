import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/helpers/date_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/chat_bubble.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_border_text_field.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/chat_event/controllers/event_chat_controller.dart';

class EventChatView extends GetView<EventChatController> {
  const EventChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          controller.title.value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Color(0xFFA5A5A5),
              ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 4,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.chevron_left,
              color: Color(0xFFA5A5A5),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.chats.isEmpty) {
                return const SizedBox.shrink();
              }

              // scroll to bottom when keyboard open
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (MediaQuery.of(context).viewInsets.bottom > 0) {
                  if (controller.scrollController.hasClients) {
                    controller.scrollController.animateTo(
                      controller.scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                }
              });

              var grouped = controller.groupedMessages;
              var dateKeys = grouped.keys.toList(); // oldest dulu

              final items = <Widget>[];
              for (var date in dateKeys) {
                items.add(
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        DateHelper.formatChatDate(date),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: const Color(0xFFA5A5A5)),
                      ),
                    ),
                  ),
                );
                var chatsInDate = grouped[date]!;
                for (var i = 0; i < chatsInDate.length; i++) {
                  final msg = chatsInDate[i];
                  final isFirstFromUser =
                      i == 0 || chatsInDate[i - 1].userId != msg.userId;
                  items.add(
                    ChatBubble(
                      chat: msg,
                      isSender: msg.userId == controller.user.id,
                      showUserInfo: isFirstFromUser,
                    ),
                  );
                }
              }
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 16,
                ),
                controller: controller.scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount:
                    items.length + (controller.hasReacheMax.value ? 0 : 1),
                itemBuilder: (context, index) {
                  // Slot loading di atas (untuk load older)
                  if (!controller.hasReacheMax.value && index == 0) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  // Hitung index sebenarnya di `items`
                  final itemIndex =
                      controller.hasReacheMax.value ? index : index - 1;

                  if (itemIndex < 0 || itemIndex >= items.length) {
                    return const SizedBox.shrink();
                  }

                  return items[itemIndex];
                },
              );
            }),
          ),
          Obx(
            () => Container(
              padding: const EdgeInsets.all(16),
              child: GradientBorderTextField(
                controller: controller.messageController,
                onChanged: (value) => controller.message.value = value,
                hintText: 'Type Something',
                suffixIcon: Visibility(
                  visible: controller.message.value.isNotEmpty,
                  child: InkWell(
                    onTap: () => controller.storeChat(),
                    child: SvgPicture.asset('assets/icons/ic_send.svg'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
