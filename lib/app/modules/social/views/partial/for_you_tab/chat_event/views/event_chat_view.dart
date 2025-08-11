import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/theme/elevated_btn_theme.dart';
import 'package:zest_mobile/app/core/shared/widgets/chat_bubble.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_border_text_field.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/chat_event/controllers/event_chat_controller.dart';

class EventChatView extends GetView<EventChatController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Event Chat',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Color(0xFFA5A5A5),
                ),
          ),
          actions: [
            SvgPicture.asset('assets/icons/ic_more_horiz.svg'),
            const SizedBox(width: 16),
          ],
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
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          child: GradientBorderTextField(
            controller: controller.messageController,
            hintText: 'Type Something',
            suffixIcon: InkWell(
              onTap: () {
                controller.storeChat();
              },
              child: SvgPicture.asset(
                'assets/icons/ic_send.svg',
              ),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.chats.isEmpty) {
            return const SizedBox.shrink();
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: controller.chats.length +
                (controller.hasReacheMax.value ? 0 : 1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            physics: const BouncingScrollPhysics(),
            controller: controller.scrollController,
            itemBuilder: (context, index) {
              if (index == controller.chats.length) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }
              switch (controller.chats[index].type) {
                case 1:
                  return Center(
                    child: Text(
                      "${controller.chats[index].user?.name ?? '-'} joined",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13.sp,
                            color: const Color(0xFF858585),
                          ),
                    ),
                  );
                case 4:
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: kAppDefaultButtonGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Event created",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 13.sp,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ),
                  );

                default:
                  final isSender =
                      controller.chats[index].userId == controller.user.id;

                  return ChatBubble(
                    isSender: isSender,
                    chat: controller.chats[index],
                  );
              }
            },
          );
        }));
  }
}
