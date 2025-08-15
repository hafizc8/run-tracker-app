import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/extension/initial_profile_empty.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/inbox/controllers/inbox_club_controller.dart';

class InboxClubView extends GetView<InboxClubController> {
  const InboxClubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.page == 1) {
        return const ShimmerLoadingList(
          itemCount: 5,
          itemHeight: 100,
        );
      }
      return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          height: 16,
        ),
        shrinkWrap: true,
        itemCount:
            controller.chats.length + (controller.hasReacheMax.value ? 0 : 1),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == controller.chats.length) {
            return Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const CircularProgressIndicator(),
              ),
            );
          }

          final chat = controller.chats[index];

          return InkWell(
            onTap: () => controller.goToRoomChatClub(chat),
            child: Row(
              children: [
                _buildAvatar(
                  context,
                  chat.relateableClub?.imageUrl,
                  chat.relateableClub?.name,
                  isShowIcon: true,
                  isClub: true,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            chat.relateableClub?.name ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.sp,
                                  color: Color(0xFFA5A5A5),
                                ),
                          ),
                        ],
                      ),
                      Text(
                        chat.message ?? '-',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 13.sp,
                              color: Color(0xFFA5A5A5),
                            ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildAvatar(
    BuildContext context,
    String? imageUrl,
    String? name, {
    bool isShowIcon = false,
    bool isEvent = false,
    bool isClub = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? '',
            width: 43.r,
            height: 43.r,
            fit: BoxFit.cover,
            placeholder: (context, url) => ShimmerLoadingCircle(
              size: 43.r,
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: 30.r,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              child: Text(
                (name ?? '-').toInitials(),
              ),
            ),
          ),
        ),
        if (isShowIcon)
          Positioned(
            right: -10,
            bottom: 0,
            child: Container(
              width: 26.r,
              height: 26.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: isEvent
                  ? SvgPicture.asset(
                      'assets/icons/ic_date.svg',
                      height: 15.r,
                      width: 15.r,
                      color: Color(0xFF292929),
                    )
                  : isClub
                      ? SvgPicture.asset(
                          'assets/icons/ic_club_inbox.svg',
                          height: 15.r,
                          width: 15.r,
                          color: Color(0xFF292929),
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
            ),
          )
      ],
    );
  }
}
