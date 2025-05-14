import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
          if (controller.clubs.isEmpty &&
              controller.search.value.isEmpty &&
              !controller.isLoading.value) {
            return SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  'You Have Not Joined Any Club',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
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
              return _buildClubsListItem(context: context, club: club);
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}