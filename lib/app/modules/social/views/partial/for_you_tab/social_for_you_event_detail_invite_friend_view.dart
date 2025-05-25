import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_blue_checkbox.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_invite_controller.dart';

class SocialForYouEventDetaiInviteFriendView
    extends GetView<EventInviteController> {
  const SocialForYouEventDetaiInviteFriendView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Container(
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
      ),
      bottomNavigationBar: _buildBottomBar(context),
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
        'Invite a Friend',
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

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: OutlinedButtonTheme(
                data: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size.fromHeight(40),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                child: OutlinedButton(
                  onPressed: controller.invites.isEmpty ||
                          controller.isLoadingReserveFriend.value
                      ? null
                      : () {
                          controller.reserveEvent(isReserved: true);
                        },
                  child: Visibility(
                    visible: !controller.isLoadingReserveFriend.value,
                    replacement: const CircularProgressIndicator(),
                    child: Text(
                      'Reserve',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButtonTheme(
                data: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: controller.invites.isEmpty ||
                          controller.isLoadingInviteFriend.value
                      ? null
                      : () {
                          controller.inviteEvent(isReserved: false);
                        },
                  child: Visibility(
                    visible: !controller.isLoadingInviteFriend.value,
                    replacement: const CircularProgressIndicator(),
                    child: Text(
                      'Invite',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendListItem(BuildContext context, UserMiniModel friend) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'John Doe',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const Spacer(),
          // checkbox
          Obx(
            () => CustomBlueCheckbox(
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
