import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/detail_challenge/controllers/detail_challenge_invite_friend_controller.dart';

class DetailChallengeInviteFriendView
    extends GetView<DetailChallengeInviteController> {
  const DetailChallengeInviteFriendView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.loadFriends(refresh: true);
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller.scrollControllerFriend,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) => controller.search.value = value,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Friend',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Obx(
                    () => Text(
                      '(${controller.invites.length} Selected)',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.resultSearchEmpty.value &&
                    controller.pageFriend == 1) {
                  return Center(
                    child: Text(
                      'No result for : ${controller.search.value}',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  );
                }
                if (controller.isLoadingFriend.value &&
                    controller.pageFriend == 1) {
                  return const ShimmerLoadingList(
                    itemCount: 10,
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.friends.length +
                      (controller.hasReacheMaxFriend.value ? 0 : 1),
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
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.onBackground,
          size: 35,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Invite a Friends',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: Colors.transparent,
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Obx(
        () => SizedBox(
          height: 55,
          width: double.infinity,
          child: GradientElevatedButton(
            onPressed: controller.invites.isEmpty ||
                    controller.isLoadingInviteFriend.value
                ? null
                : () {
                    controller.invite();
                  },
            child: Visibility(
              visible: !controller.isLoadingInviteFriend.value,
              replacement: CustomCircularProgressIndicator(),
              child: Text(
                'Invite',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendListItem(BuildContext context, UserMiniModel friend) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: friend.imageUrl ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const ShimmerLoadingCircle(size: 50),
              errorWidget: (context, url, error) => const CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage('assets/images/empty_profile.png'),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              friend.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          // checkbox
          Obx(
            () => Checkbox(
              value: controller.invites.contains(friend),
              onChanged: (val) {
                controller.toggleInvite(friend);
              },
            ),
          ),
        ],
      ),
    );
  }
}
