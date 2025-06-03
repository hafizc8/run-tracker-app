import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/club_privacy_enum.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/social/views/partial/search/controllers/social_search_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

// ignore: must_be_immutable
class SearchClubCard extends StatelessWidget {
  SearchClubCard({super.key, required this.club, this.cardWidth = 115, this.cardHeight = 190, this.showDescription = false});

  final ClubModel club;
  final controller = Get.find<SocialSearchController>();
  double cardWidth = 115;
  double cardHeight = 190;
  bool showDescription = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: cardWidth,
          height: cardHeight * 0.62,
          decoration: const BoxDecoration(
            color: Color(0xFF474747),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 0,
            left: 16,
            right: 16,
          ),
          child: Column(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: club.imageUrl ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ShimmerLoadingCircle(size: 50),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/images/empty_profile.png'),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                club.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
              Visibility(
                visible: showDescription,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    club.description ?? 'No description',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: const Color(0xFF9E9E9E),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: cardWidth,
          decoration: const BoxDecoration(
            color: Color(0xFF474747),
          ),
          padding: const EdgeInsets.only(
            right: 16,
            left: 16,
            bottom: 16,
          ),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '${NumberHelper().formatNumberToK(club.clubUsersCount ?? 0)} '),
                    TextSpan(
                      text: 'Members',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: const Color(0xFF9E9E9E)
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: cardWidth,
          height: cardHeight * 0.32,
          decoration: const BoxDecoration(
            color: Color(0xFF3C3C3C),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 0,
            left: 16,
            right: 16,
          ),
          child: Column(
            children: [
              Visibility(
                visible: club.privacy == ClubPrivacyEnum.public,
                replacement: SizedBox(
                  height: 30,
                  child: GradientOutlinedButton(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    onPressed: () {
                      Get.toNamed(AppRoutes.previewClub, arguments: club.id);
                    },
                    child: Visibility(
                      visible: club.id == controller.clubId.value,
                      replacement: Text(
                        'Details',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
                child: SizedBox(
                  height: 30,
                  child: GradientOutlinedButton(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    onPressed: () {
                      if (!(club.isJoined ?? false)) {
                        controller.joinClub(club.id ?? '');
                      } else {
                        Get.snackbar('Error', 'You have joined the club');
                      }
                    },
                    child: Visibility(
                      visible: club.id == controller.clubId.value,
                      replacement: Text(
                        (club.isJoined ?? false)
                          ? 'Joined'
                          : 'Join',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}