import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/extension/follow_extension.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_chip.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_followers_controller.dart';

class SocialYourPageFollowersView extends GetView<SocialFollowersController> {
  const SocialYourPageFollowersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Visibility(
            visible:
                controller.friends.isNotEmpty || controller.isLoading.value,
            child: TextFormField(
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
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Followers',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Obx(
              () => Text(
                '(${controller.friends.length})',
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
          if (controller.friends.isEmpty &&
              controller.search.value.isEmpty &&
              !controller.isLoading.value) {
            return Text(
              'You Have No Followers',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
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

              final user = controller.friends[index];
              return Column(
                children: [
                  _buildFollowersListItem(context, user),
                  const SizedBox(height: 15),
                ],
              );
            },
          );
        })
      ],
    );
  }

  Widget _buildFollowersListItem(BuildContext context, UserMiniModel user) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        user.name,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      // trailing: Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     CustomChip(
      //         child: Text(
      //       {'is_following': user.isFollowing, 'is_followed': user.isFollowed}
      //           .followStatus,
      //     ))
      //   ],
      // ),
    );
  }
}
