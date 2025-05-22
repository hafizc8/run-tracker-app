import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/controllers/detail_club_controller.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/tab_bar_club_view.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class DetailClubView extends GetView<DetailClubController> {
  const DetailClubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Club Details'),
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
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const ShimmerLoadingList(
                itemCount: 5,
                itemHeight: 100,
              );
            }

            return Column(
              children: [
                _buildClubInfo(context: context),
                _buildClubContent(),
              ],
            );
          }
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildClubInfo({
    required BuildContext context
  }) {
    ClubModel? club = controller.club.value;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: club?.imageUrl ?? '',
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ShimmerLoadingCircle(size: 55),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage('assets/images/empty_profile.png'),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.crown,
                        size: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
                        child: Text(
                          club?.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary,
                                fontSize: 20
                              ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.updateClub, arguments: club?.id),
                        child: Icon(
                          Icons.edit,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                        child: Text(
                          '${club?.createdAt?.toDDMMMyyyyString()} - ${club?.province}, ${club?.country}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            club?.description ?? '',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.memberListInClub, arguments: club?.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Text(
                    '${club?.clubUsersCount ?? 0} Members',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.snackbar('Coming soon', 'Feature is coming soon'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    size: 16.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.inviteToClub, arguments: club?.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    Icons.person_add_outlined,
                    size: 16.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.snackbar('Coming soon', 'Feature is coming soon'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.shareFromSquare,
                    size: 14.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClubContent() {
    return Column(
      children: [
        const SizedBox(height: 10),
        TabBarClub(),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Builder(
      builder: (context) => FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () async {
          await showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              MediaQuery.of(context).size.width - 100,
              MediaQuery.of(context).size.height - 200,
              20,
              0,
            ),
            surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
            items: [
              PopupMenuItem<String>(
                value: 'create_an_event',
                child: Text(
                  'Create an Event',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuItem<String>(
                value: 'create_a_challange',
                child: Text(
                  'Create a Challange',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
            elevation: 8.0,
          ).then((value) {
            if (value == 'create_an_event') {
              // do edit action
            } else if (value == 'create_a_challange') {
              // do delete action
            }
          });
        },
      ),
    );
  }
}