import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/profile/controllers/profile_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/see_all_participant_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SocialForYouEventDetailSeelAllParticipantView
    extends GetView<SeeAllParticipantController> {
  const SocialForYouEventDetailSeelAllParticipantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                '${controller.friends.length} Participants',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isLoading.value && controller.page == 1) {
                return const ShimmerLoadingList(
                  itemCount: 10,
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.friends.length +
                    (controller.hasReacheMax.value ? 0 : 1),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == controller.friends.length) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  }
                  final friend = controller.friends[index];
                  return _buildFriendListItem(context, friend);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.primary,
          size: 35,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Participants',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: Colors.transparent,
    );
  }

  Widget _buildFriendListItem(BuildContext context, EventUserModel friend) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          if (sl<AuthService>().user?.id == friend.user?.id) return;
          Get.delete<ProfileController>();
          Get.toNamed(AppRoutes.profileUser, arguments: friend.user?.id);
        },
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: friend.user?.imageUrl ?? '-',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const ShimmerLoadingCircle(size: 50),
                errorWidget: (context, url, error) => const CircleAvatar(
                  radius: 32,
                  backgroundImage:
                      AssetImage('assets/images/empty_profile.png'),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                friend.user?.name ?? '-',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
