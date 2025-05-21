import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_blue_checkbox.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/club/partial/invite_to_club/controllers/invite_to_club_controller.dart';

class InviteToClubView extends GetView<InviteToClubController> {
  const InviteToClubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Invite to Club'),
        automaticallyImplyLeading: false,
        elevation: 1,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.chevron_left,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
      body: SingleChildScrollView(
        controller: controller.followersScrollController,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) => controller.onSearchChanged(value),
                decoration: InputDecoration(
                  hintText: 'Search',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                      '(${controller.selectedUser.length} Selected)',
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
                if (controller.resultSearchEmpty.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'No result for “${controller.search.value}”',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  );
                }
                if (controller.userFollowers.isEmpty &&
                    controller.search.value.isEmpty &&
                    !controller.isLoading.value) {
                  return Text(
                    'You Have No Friends',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.userFollowers.length + (controller.hasReacheMax.value ? 0 : 1),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == controller.userFollowers.length) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    }
          
                    final user = controller.userFollowers[index];
                    final isChecked = controller.selectedUser.contains(user?.id);

                    return Column(
                      children: [
                        _buildMemberListItem(
                          context: context,
                          friend: user,
                          isChecked: isChecked,
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberListItem({required BuildContext context, UserMiniModel? friend, bool isChecked = false}) {
    print('friend.id: ${friend?.id}, isChecked: $isChecked');
    return ListTile(
      leading: ClipOval(
        child: CachedNetworkImage(
          imageUrl: friend?.imageUrl ?? '',
          width: 37,
          height: 37,
          fit: BoxFit.cover,
          placeholder: (context, url) => const ShimmerLoadingCircle(size: 37),
          errorWidget: (context, url, error) => const CircleAvatar(
            radius: 37,
            backgroundImage: AssetImage('assets/images/empty_profile.png'),
          ),
        ),
      ),
      title: Text(
        friend?.name ?? '',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: !(friend?.isJoinedToClub ?? false) ? CustomBlueCheckbox(
        value: isChecked,
        onChanged: (_) => controller.toggleSelection(friend?.id ?? ''),
      ) :
      Text(
        'Joined',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey),
      ),
      onTap: () => !(friend?.isJoinedToClub ?? false) ? controller.toggleSelection(friend?.id ?? '') : null,
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
        () => Visibility(
          visible: !controller.isLoadingInviteToClub.value,
          replacement: const Center(child: CircularProgressIndicator()),
          child: Expanded(
            child: ElevatedButtonTheme(
              data: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary,
                  foregroundColor:
                      Theme.of(context).colorScheme.onPrimary,
                  minimumSize: const Size.fromHeight(40),
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  controller.inviteToClub();
                },
                child: Text(
                  'Invite',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}