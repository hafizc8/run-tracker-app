import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/club_privacy_enum.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/widgets/participants_avatars.dart';
import 'package:zest_mobile/app/modules/club/partial/preview_club/controllers/preview_club_controller.dart';

class PreviewClubView extends GetView<PreviewClubController> {
  const PreviewClubView({super.key});

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

            ClubModel? club = controller.club.value;

            return Column(
              children: [
                _buildClubInfo(context: context, club: club),
                _buildClubContent(context: context, club: club),
              ],
            );
          }
        ),
      ),
      bottomNavigationBar: Obx(
        () {
          return Visibility(
            visible: !controller.isLoading.value,
            replacement: const Center(child: CircularProgressIndicator()),
            child: _buildBottomBar(context: context, club: controller.club.value),
          );
        }
      ),
    );
  }

  Widget _buildClubInfo({
    required BuildContext context,
    required ClubModel? club
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 45),
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: club?.imageUrl ?? '',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              placeholder: (context, url) => const ShimmerLoadingCircle(size: 90),
              errorWidget: (context, url, error) => const CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage('assets/images/empty_profile.png'),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            club?.name ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 20
            ),
          ),

          const SizedBox(height: 5),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.date_range,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${club?.createdAt?.toDDMMMyyyyString()} - ${club?.province}, ${club?.country}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
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
              InkWell(
                onTap: () => Get.snackbar('Coming soon', 'Feature is coming soon'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  Widget _buildClubContent({
    required BuildContext context,
    required ClubModel? club
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'About Club',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            club?.description ?? 'No description',
            style: Theme.of(context).textTheme.bodySmall,
          ),


          const SizedBox(height: 24),
          Text(
            'Event Created',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            (club?.eventsCount ?? 0).toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),


          const SizedBox(height: 24),
          Text(
            'Challange Created',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            (club?.challengeCount ?? 0).toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),


          const SizedBox(height: 24),
          Text(
            'Members',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Obx(
            () {
              if (controller.isLoadingMembers.value) {
                return const ShimmerLoadingCircle(
                  size: 30,
                );
              }

              return ParticipantsAvatars(imageUrls: controller.memberAvatars);
            }
          ),
          const SizedBox(height: 3),
          Text(
            controller.formatFriendsText(friendsNames: club?.friendsNames, friendsTotal: club?.friendsTotal),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar({
    required BuildContext context,
    required ClubModel? club,
  }) {
    return Obx(
      () {
        if (controller.isLoadingJoin.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final theme = Theme.of(context);
        final isPublic = club?.privacy == ClubPrivacyEnum.public;
        final isPrivatePending = club?.privacy == ClubPrivacyEnum.private && (club?.isPendingJoin ?? false);
        final isJoined = club?.isJoined ?? false;

        if (isPublic || isPrivatePending) {
          final buttonText = isPublic ? 'Join Club' : 'Accept Invitation';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                minimumSize: const Size.fromHeight(40),
              ),
              onPressed: () => controller.joinClub(),
              child: Text(
                buttonText,
                style: theme.textTheme.labelSmall,
              ),
            ),
          );
        }
        
        return Padding(
          padding: const EdgeInsets.all(22.0),
          child: Text(
            isJoined
            ? 'You are a member of this club.'
            : 'This club is private. Only invited members can join.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        );
      }
    );
  }

}