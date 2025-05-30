import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_club_search_controller.dart';

class SocialYourPageClubsView extends GetView<SocialClubSearchController> {
  const SocialYourPageClubsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller.searchController,
          onChanged: (value) => controller.onSearchChanged(value),
          decoration: InputDecoration(
            hintText: 'Search',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
            fillColor: Theme.of(context).colorScheme.background,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Clubs',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Obx(
              () => Text(
                '(${controller.clubs.length})',
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
            return Column(
              children: [
                const SizedBox(height: 30),
                SvgPicture.asset('assets/icons/ic_not_found.svg', width: 160),
                const SizedBox(height: 16),
                Text(
                  'Nothing Here Yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF5C5C5C),
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Try a different keyword',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF5C5C5C),
                  ),
                ),
              ],
            );
          }
          if (controller.clubs.isEmpty &&
              controller.search.value.isEmpty &&
              !controller.isLoading.value) {
            return Column(
              children: [
                const SizedBox(height: 30),
                SvgPicture.asset('assets/icons/ic_no_club_yet.svg', width: 160),
                const SizedBox(height: 16),
                Text(
                  'Nothing Here Yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF5C5C5C),
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Try a different keyword',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF5C5C5C),
                  ),
                ),
              ],
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 3,
            ),
            itemCount: controller.clubs.length + (controller.hasReacheMax.value ? 0 : 1),
            itemBuilder: (context, index) {
              if (index == controller.clubs.length) {
                return Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const CircularProgressIndicator(),
                  ),
                );
              }

              final club = controller.clubs[index];
              return InkWell(
                onTap: () => controller.goToClubDetails(club),
                child: _buildClubsListItem(context: context, club: club),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildClubsListItem({required BuildContext context, required ClubModel club}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: club.imageUrl ?? '',
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const ShimmerLoadingCircle(size: 68),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    radius: 68,
                    backgroundImage: AssetImage('assets/images/empty_profile.png'),
                  ),
                ),
              ),
              (club.isOwner ?? false) ? Positioned(
                bottom: 0,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.crown,
                    size: 12,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                ),
              ) : const SizedBox(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          club.name ?? '',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: const Color(0xFFDCDCDC),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}