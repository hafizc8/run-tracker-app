import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/models/enums/club_privacy_enum.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_circular_progress_indicator.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/social/views/partial/search/controllers/social_search_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/search/views/widgets/search_club_card.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SocialSearchView extends GetView<SocialSearchController> {
  const SocialSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildCustomTabBar(context),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: controller.tabBarController,
                children: [
                  _buildFriendsTab(context),
                  _buildClubsTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Search',
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
    );
  }

  Widget _buildCustomTabBar(BuildContext context) {
    return Obx(() {
      BorderRadiusGeometry indicatorBorderRadius;

      int currentTab = controller.selectedIndex.value;

      if (currentTab == 0) {
        indicatorBorderRadius = const BorderRadius.only(
          topLeft: Radius.circular(11),
          bottomLeft: Radius.circular(11),
        );
      } else {
        indicatorBorderRadius = const BorderRadius.only(
          topRight: Radius.circular(11),
          bottomRight: Radius.circular(11),
        );
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 38,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: TabBar(
            controller: controller.tabBarController,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: indicatorBorderRadius,
            ),
            automaticIndicatorColorAdjustment: false,
            indicatorWeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerHeight: 0,
            labelColor: Theme.of(context).colorScheme.onPrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
            unselectedLabelStyle:
                Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
            tabs: const [
              Tab(text: 'Friends'),
              Tab(text: 'Clubs'),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFriendsTab(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            onChanged: (value) => controller.onSearchChanged(value),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
            decoration: InputDecoration(
              hintText: "Search for a friend",
              suffixIcon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.primary,
              ),
              fillColor: Theme.of(context).colorScheme.background,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Visibility(
            visible: controller.friends.isNotEmpty ||
                controller.search.value.isNotEmpty ||
                controller.isLoadingFriends.value,
            replacement: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'People you may know',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  if (controller.isLoadingPeopleYouMayKnow.value) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade700,
                      child: SizedBox(
                        height: 150,
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) => Container(
                            width: 120,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                // Avatar
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Name
                                Container(
                                  height: 12,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Follow Button
                                Container(
                                  height: 32,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    height: 180, // Atur tinggi agar horizontal scroll terlihat
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.friendsPeopleYouMayKnow.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        UserMiniModel user =
                            controller.friendsPeopleYouMayKnow[index];
                        return InkWell(
                          onTap: () => Get.toNamed(AppRoutes.profileUser,
                              arguments: user.id),
                          child: Card(
                            surfaceTintColor:
                                Theme.of(context).colorScheme.background,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(maxWidth: 130),
                              padding: const EdgeInsets.all(12),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: user.imageUrl ?? '',
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const ShimmerLoadingCircle(size: 45),
                                      errorWidget: (context, url, error) =>
                                          const CircleAvatar(
                                        radius: 45,
                                        backgroundImage: AssetImage(
                                            'assets/images/empty_profile.png'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    user.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12,
                                        ),
                                  ),
                                  const SizedBox(height: 24),
                                  Flexible(
                                    child: Obx(
                                      () => SizedBox(
                                        height: 38,
                                        child: GradientOutlinedButton(
                                          onPressed: () {
                                            if (user.isFollowing == 1 &&
                                                user.isFollower == 1) {
                                              Get.snackbar('Coming soon',
                                                  'Feature chat coming soon');
                                              return;
                                            }

                                            if (user.isFollowing == 1) {
                                              controller.unFollow(user.id);
                                            } else {
                                              controller.follow(user.id);
                                            }
                                          },
                                          child: Visibility(
                                            visible: user.id ==
                                                controller.userId.value,
                                            replacement: Visibility(
                                              visible: user.isFollowing == 0,
                                              replacement: Visibility(
                                                visible: user.isFollower == 0,
                                                replacement: Icon(
                                                  Icons.chat_bubble_outline,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  size: 18,
                                                ),
                                                child: Icon(
                                                  Icons
                                                      .person_remove_alt_1_outlined,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  size: 18,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.person_add_alt,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                size: 18,
                                              ),
                                            ),
                                            child: Center(
                                              child:
                                                  CustomCircularProgressIndicator(
                                                      indicatorSize: 15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
            child: Obx(() {
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
              return Obx(
                () => Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: controller.friends.length +
                        (controller.hasReacheMax.value ? 0 : 1),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    controller: controller.scrollFriendsController
                      ..addListener(() {
                        var maxScroll = controller
                                .scrollFriendsController.position.pixels >=
                            controller.scrollFriendsController.position
                                    .maxScrollExtent -
                                200;

                        if (maxScroll && !controller.hasReacheMax.value) {
                          controller.searchFriends(controller.search.value);
                        }
                      }),
                    itemBuilder: (context, index) {
                      if (index == controller.friends.length) {
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      }

                      UserMiniModel user = controller.friends[index];

                      return ListTile(
                        onTap: () => Get.toNamed(AppRoutes.profileUser,
                            arguments: user.id),
                        leading: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: user.imageUrl ?? '',
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const ShimmerLoadingCircle(size: 32),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              radius: 32,
                              backgroundImage:
                                  AssetImage('assets/images/empty_profile.png'),
                            ),
                          ),
                        ),
                        title: Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                  ),
                        ),
                        trailing:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          Obx(
                            () => InkWell(
                              onTap: () {
                                if (user.isFollowing == 1 &&
                                    user.isFollower == 1) {
                                  Get.snackbar('Coming soon',
                                      'Feature chat coming soon');
                                  return;
                                }

                                if (user.isFollowing == 1) {
                                  controller.unFollow(user.id);
                                } else {
                                  controller.follow(user.id);
                                }
                              },
                              child: Visibility(
                                visible: user.id == controller.userId.value,
                                replacement: Visibility(
                                  visible: user.isFollowing == 0,
                                  replacement: Visibility(
                                    visible: user.isFollower == 0,
                                    replacement: Icon(
                                      Icons.chat_bubble_outline,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 23,
                                    ),
                                    child: Icon(
                                      Icons.person_remove_alt_1_outlined,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 23,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person_add_alt,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 23,
                                  ),
                                ),
                                child: Center(
                                  child: CustomCircularProgressIndicator(
                                      indicatorSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ]),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildClubsTab(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        controller: (controller.searchClub.value.isEmpty)
            ? controller.scrollExploreClubController
            : controller.scrollClubsController,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              onChanged: (value) => controller.onSearchClubChanged(value),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
              decoration: InputDecoration(
                hintText: "Search for a club",
                suffixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                fillColor: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Visibility(
              visible: controller.clubs.isNotEmpty ||
                  controller.searchClub.value.isNotEmpty ||
                  controller.isLoadingClubs.value,
              replacement: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Join a Club That Matches Your Passion',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (controller.isLoadingClubYouMayKnow.value) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade700,
                        child: SizedBox(
                          height: 150,
                          child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) => Container(
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Name
                                  Container(
                                    height: 12,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Follow Button
                                  Container(
                                    height: 32,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 210,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.clubMayYouKnow.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          ClubModel club = controller.clubMayYouKnow[index];
                          return InkWell(
                            onTap: () => Get.toNamed(AppRoutes.previewClub,
                                arguments: club.id),
                            child: SearchClubCard(
                              club: club,
                              cardWidth: 115,
                              cardHeight: 180,
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: controller.clubExplore.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: Text(
                        'Explore Clubs',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  Obx(() {
                    return GridView.builder(
                      padding: const EdgeInsets.only(
                          bottom: 16, right: 16, left: 16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.80,
                      ),
                      itemCount: controller.clubExplore.length,
                      itemBuilder: (context, index) {
                        ClubModel club = controller.clubExplore[index];

                        return InkWell(
                          onTap: () => Get.toNamed(AppRoutes.previewClub,
                              arguments: club.id),
                          child: SearchClubCard(
                            club: club,
                            cardWidth: double.infinity,
                            cardHeight: 200,
                            showDescription: true,
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
              child: Obx(() {
                if (controller.resultSearchEmptyClub.value) {
                  return Column(
                    children: [
                      const SizedBox(height: 30),
                      SvgPicture.asset('assets/icons/ic_no_club_yet.svg',
                          width: 160),
                      const SizedBox(height: 16),
                      Text(
                        'Nothing Here Yet',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
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
                return Obx(
                  () => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.clubs.length +
                        (controller.hasReacheMaxClub.value ? 0 : 1),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      if (index == controller.clubs.length) {
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      }

                      ClubModel club = controller.clubs[index];

                      return ListTile(
                        onTap: () => Get.toNamed(AppRoutes.previewClub,
                            arguments: club.id),
                        leading: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: club.imageUrl ?? '',
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const ShimmerLoadingCircle(size: 32),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              radius: 32,
                              backgroundImage:
                                  AssetImage('assets/images/empty_profile.png'),
                            ),
                          ),
                        ),
                        title: Text(
                          club.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                        ),
                        subtitle: Text(
                          '${club.province}, ${club.country}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF858585),
                                    fontSize: 11,
                                  ),
                        ),
                        trailing: Visibility(
                          visible: club.privacy == ClubPrivacyEnum.public,
                          child: SizedBox(
                            height: 35,
                            width: 65,
                            child: GradientOutlinedButton(
                              onPressed: () {
                                if (!(club.isJoined ?? false)) {
                                  controller.joinClub(club.id ?? '');
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    'You have joined the club',
                                  );
                                }
                              },
                              child: Visibility(
                                visible: club.id == controller.clubId.value,
                                replacement: Text(
                                  (club.isJoined ?? false) ? 'Joined' : 'Join',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ]),
      );
    });
  }
}
