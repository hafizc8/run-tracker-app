import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/club_member_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/club/partial/member_list_club/controllers/member_list_club_controller.dart';

class MemberListClubView extends GetView<MemberListClubController> {
  const MemberListClubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Members'),
        automaticallyImplyLeading: false,
        elevation: 1,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.chevron_left,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: controller.memberListScrollController,
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const ShimmerLoadingList(
                itemCount: 10,
                itemHeight: 60,
              );
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Participants',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Obx(
                        () => Text(
                          '(${controller.clubMembers.length})',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.clubMembers.length + (controller.hasReacheMax.value ? 0 : 1),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == controller.clubMembers.length) {
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      }
              
                      final member = controller.clubMembers[index];
                      return Column(
                        children: [
                          _buildMemberListItem(context, member),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Widget _buildMemberListItem(BuildContext context, ClubMemberModel? members) {
    return InkWell(
      onTapDown: (details) async {
        if (members?.role != 2) {
          return;
        }

        final result = await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            0,
            0,
          ),
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          items: [
            PopupMenuItem<String>(
              value: 'assign_as_admin',
              child: Text(
                'Assign as Admin',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            PopupMenuItem<String>(
              value: 'remove_from_club',
              child: Text(
                'Remove from Club',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );

        if (result != null) {
          // show alert
          Get.snackbar('Coming soon', 'Feature is coming soon');
        }
      },
      child: ListTile(
        leading: ClipOval(
          child: CachedNetworkImage(
            imageUrl: members?.user?.imageUrl ?? '',
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
          members?.user?.name ?? '',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          members?.roleText ?? '',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: Colors.grey),
        ),
      ),
    );
  }
}