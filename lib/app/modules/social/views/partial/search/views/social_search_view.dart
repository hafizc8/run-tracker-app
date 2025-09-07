import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            _buildCustomTabBar(context),
            SizedBox(height: 16.h),
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
            ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
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
        indicatorBorderRadius = BorderRadius.only(
          topLeft: Radius.circular(11.r),
          bottomLeft: Radius.circular(11.r),
        );
      } else {
        indicatorBorderRadius = BorderRadius.only(
          topRight: Radius.circular(11.r),
          bottomRight: Radius.circular(11.r),
        );
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        height: 38.h,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(16.r),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
        SizedBox(height: 16.h),
        Obx(
          () => Visibility(
            visible: controller.friends.isNotEmpty ||
                controller.search.value.isNotEmpty ||
                controller.isLoadingFriends.value,
            replacement: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'People you may know',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                SizedBox(height: 16.h),
                Obx(() {
                  if (controller.isLoadingPeopleYouMayKnow.value) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade700,
                      child: SizedBox(
                        height: 150.h,
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 10.w),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) => Container(
                            width: 120.w,
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: 12.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              children: [
                                // Avatar
                                Container(
                                  width: 48.r,
                                  height: 48.r,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                // Name
                                Container(
                                  height: 12.h,
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                // Follow Button
                                Container(
                                  height: 32.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20.r),
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
                    height:
                        180.h, // Atur tinggi agar horizontal scroll terlihat
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.friendsPeopleYouMayKnow.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 10.w),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 130.r),
                              padding: EdgeInsets.all(12.w),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: user.imageUrl ?? '',
                                      width: 45.r,
                                      height: 45.r,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          ShimmerLoadingCircle(size: 45.r),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        radius: 45.r,
                                        backgroundImage: const AssetImage(
                                          'assets/images/empty_profile.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    user.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12.sp,
                                        ),
                                  ),
                                  SizedBox(height: 24.h),
                                  Flexible(
                                    child: Obx(
                                      () => SizedBox(
                                        height: 26.h,
                                        child: GradientOutlinedButton(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 5.h,
                                          ),
                                          onPressed: () {
                                            if (user.isFollowing == 1 &&
                                                user.isFollower == 1) {
                                              Get.snackbar('Coming soon',
                                                  'Feature chat coming soon');
                                              return;
                                            }

                                            if (user.isFollowing == 0) {
                                              controller.follow(user.id);
                                            }
                                          },
                                          child: Visibility(
                                            visible: user.id ==
                                                controller.userId.value,
                                            replacement: Visibility(
                                              visible: user.isFollowing == 0,
                                              replacement: SvgPicture.asset(
                                                'assets/icons/msg.svg',
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/icons/follback.svg',
                                              ),
                                            ),
                                            child:
                                                CustomCircularProgressIndicator(),
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
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                        SizedBox(height: 10.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                            margin: EdgeInsets.symmetric(vertical: 10.h),
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
                            width: 32.r,
                            height: 32.r,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                ShimmerLoadingCircle(size: 32.r),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 32.r,
                              backgroundImage: const AssetImage(
                                  'assets/images/empty_profile.png'),
                            ),
                          ),
                        ),
                        title: Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 12.sp,
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

                                if (user.isFollowing == 0) {
                                  controller.follow(user.id);
                                }
                              },
                              child: Visibility(
                                visible: user.id == controller.userId.value,
                                replacement: Visibility(
                                  visible: user.isFollowing == 0,
                                  replacement: SvgPicture.asset(
                                    'assets/icons/msg.svg',
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/follback.svg',
                                  ),
                                ),
                                child: CustomCircularProgressIndicator(),
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
          Obx(
            () => Visibility(
              visible: controller.clubs.isNotEmpty ||
                  controller.searchClub.value.isNotEmpty ||
                  controller.isLoadingClubs.value,
              replacement: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Join a Club That Matches Your Passion',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Obx(() {
                    if (controller.isLoadingClubYouMayKnow.value) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade700,
                        child: SizedBox(
                          height: 150.h,
                          child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 10.w),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) => Container(
                              width: 120.w,
                              padding: EdgeInsets.symmetric(
                                vertical: 16.h,
                                horizontal: 12.w,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Column(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 48.r,
                                    height: 48.r,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  // Name
                                  Container(
                                    height: 12.h,
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  // Follow Button
                                  Container(
                                    height: 32.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20.r),
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
                      height: 190.w,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.clubMayYouKnow.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 10.w),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemBuilder: (context, index) {
                          ClubModel club = controller.clubMayYouKnow[index];
                          return InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.previewClub, arguments: club.id);
                            },
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
                  SizedBox(height: 16.h),
                  Visibility(
                    visible: controller.clubExplore.isNotEmpty,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        bottom: 16.h,
                      ),
                      child: Text(
                        'Explore Clubs',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
                  Obx(() {
                    final double cardWidth = 177.w;
                    final double cardHeight = 240.w;

                    return GridView.builder(
                      padding: EdgeInsets.only(
                        bottom: 16.h,
                        right: 16.w,
                        left: 16.w,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        // Setiap item boleh memiliki lebar maksimal 180.w
                        // Flutter akan menyesuaikan jumlah kolomnya
                        maxCrossAxisExtent: 250.w,
                        mainAxisSpacing: 15.h,
                        crossAxisSpacing: 15.w,
                        // Anda tetap perlu rasio aspek, tapi kini lebih konsisten
                        // karena lebarnya tidak akan terlalu ekstrem.
                        childAspectRatio: cardWidth / cardHeight,
                      ),
                      itemCount: controller.clubExplore.length,
                      itemBuilder: (context, index) {
                        ClubModel club = controller.clubExplore[index];

                        return InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.previewClub, arguments: club.id);
                          },
                          child: SearchClubCard(
                            club: club,
                            cardWidth: cardWidth,
                            cardHeight: cardHeight,
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
                      SizedBox(height: 30.h),
                      SvgPicture.asset(
                        'assets/icons/ic_no_club_yet.svg',
                        width: 160.w,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Nothing Here Yet',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF5C5C5C),
                                  fontSize: 20.sp,
                                ),
                      ),
                      SizedBox(height: 3.h),
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
                        SizedBox(height: 10.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemBuilder: (context, index) {
                      if (index == controller.clubs.length) {
                        return Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      }

                      ClubModel club = controller.clubs[index];

                      return ListTile(
                        onTap: () {
                          Get.toNamed(AppRoutes.previewClub, arguments: club.id);
                        },
                        leading: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: club.imageUrl ?? '',
                            width: 32.r,
                            height: 32.r,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                ShimmerLoadingCircle(size: 32.r),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 32.r,
                              backgroundImage: const AssetImage(
                                  'assets/images/empty_profile.png'),
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
                                    fontSize: 12.sp,
                                  ),
                        ),
                        subtitle: Text(
                          '${club.province}, ${club.country}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF858585),
                                    fontSize: 11.sp,
                                  ),
                        ),
                        trailing: Visibility(
                          visible: club.privacy == ClubPrivacyEnum.public,
                          child: SizedBox(
                            height: 35.h,
                            width: 65.w,
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
                                        fontSize: 10.sp,
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
