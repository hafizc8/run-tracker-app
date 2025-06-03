import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/club_privacy_enum.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
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
        title: Text(
          'Club Details',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w300,
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 27,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () => Get.back(),
        ),
        shadowColor: Colors.black.withOpacity(0.3),
        surfaceTintColor: Colors.transparent,
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
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/images/z-background-2.svg',
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: SvgPicture.asset(
                  'assets/icons/ic_share-2.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: club?.imageUrl ?? '',
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const ShimmerLoadingCircle(size: 65),
                        errorWidget: (context, url, error) => const CircleAvatar(
                          radius: 65,
                          backgroundImage: AssetImage('assets/images/empty_profile.png'),
                        ),
                      ),
                    ),
                
                    const SizedBox(height: 16),
                
                    Text(
                      club?.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                
                    const SizedBox(height: 5),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Color(0xFF6C6C6C),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '${club?.createdAt?.toDDMMMyyyyString()} - ${club?.province}, ${club?.country}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF6C6C6C),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Container "Members" yang diposisikan
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF404040),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.groups_outlined,
                  size: 25,
                ),
                const SizedBox(width: 10),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: '${NumberHelper().formatNumberToK(club?.clubUsersCount ?? 0)} '),
                      TextSpan(
                        text: 'Members',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            club?.description ?? 'No description',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: const Color(0xFFA5A5A5),
              height: 2.3,
            ),
          ),


          const SizedBox(height: 24),
          Row(
            children: [
              SizedBox(
                width: 26,
                child: SvgPicture.asset('assets/icons/ic_shoes.svg', width: 26),
              ),
              const SizedBox(width: 12),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '${NumberHelper().formatNumberToK(club?.eventsCount ?? 0)} '),
                    TextSpan(
                      text: 'Events Created',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 26,
                child: SvgPicture.asset('assets/icons/ic_trophies.svg', width: 22),
              ),
              const SizedBox(width: 12),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '${NumberHelper().formatNumberToK(club?.challengeCount ?? 0)} '),
                    TextSpan(
                      text: 'Challanges Created',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          Text(
            'Members',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 10),
          Text(
            controller.formatFriendsText(friendsNames: club?.friendsNames, friendsTotal: club?.friendsTotal),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: const Color(0xFFA5A5A5),
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

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            height: 50,
            child: GradientElevatedButton(
              onPressed: () => controller.joinClub(),
              child: Text(
                buttonText,
                style: Theme.of(context).textTheme.labelMedium,
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