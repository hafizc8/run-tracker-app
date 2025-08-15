import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/extension/initial_profile_empty.dart';
import 'package:zest_mobile/app/core/shared/helpers/date_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/chat_bubble_user.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_border_text_field.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/user_chat/controllers/user_chat_controller.dart';

class UserChatView extends GetView<UserChatController> {
  const UserChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: controller.userMini?.imageUrl ?? '',
                width: 43.r,
                height: 43.r,
                fit: BoxFit.cover,
                placeholder: (context, url) => ShimmerLoadingCircle(size: 50.r),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 32.r,
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                  child: Text(
                    (controller.userMini?.name ?? '-').toInitials(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              controller.userMini?.name ?? '-',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFFA5A5A5),
                  ),
            ),
          ],
        ),
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
                for (var msg in chatsInDate) {
                  items.add(
                    ChatBubbleUser(
                      chat: msg,
                      isSender: msg.userId == controller.user.id,
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
