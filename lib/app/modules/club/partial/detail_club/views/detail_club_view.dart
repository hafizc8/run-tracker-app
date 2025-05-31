import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/club_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/controllers/detail_club_controller.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/controllers/club_activity_tab_controller.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/controllers/tab_bar_club_controller.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/club_activity_tab_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/event_card_dialog.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate({
    required this.tabBar,
    required this.tabBarHeight, // Tambahkan parameter tinggi
  });

  final Widget tabBar;
  final double tabBarHeight; // Tinggi aktual dari widget _buildCustomTabBar Anda

  @override
  double get minExtent => tabBarHeight;
  @override
  double get maxExtent => tabBarHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Beri Container dengan warna background scaffold agar konten di bawahnya tidak tembus saat scroll
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || tabBarHeight != oldDelegate.tabBarHeight;
  }
  // Ganti 'height' dengan 'tabBarHeight' di shouldRebuild jika itu maksudnya
  // @override
  // bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
  //   return tabBar != oldDelegate.tabBar || tabBarHeight != oldDelegate.tabBarHeight;
  // }
}

class DetailClubView extends GetView<DetailClubController> {
  DetailClubView({super.key});

  final tabBarClubController = Get.find<TabBarClubController>();
  final clubActivityTabController = Get.find<ClubActivityTabController>();

  @override
  Widget build(BuildContext context) {
    const double customTabBarHeight = 38.0;

    return Scaffold(
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const ShimmerLoadingList(
              itemCount: 5,
              itemHeight: 100,
            );
          }

          return NestedScrollView(
            controller: (tabBarClubController.selectedIndex.value == 0) ? clubActivityTabController.clubActivityScrollController : null,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                _buildSliverAppBar(context),
                SliverToBoxAdapter(
                  child: _buildClubInfo(context: context),
                ),
                SliverPersistentHeader(
                  delegate: _SliverTabBarDelegate(
                    tabBar: _buildCustomTabBar(context),
                    tabBarHeight: customTabBarHeight,
                  ),
                  pinned: true,
                ),
              ];
            },
            body: _buildTabBarView(context), // Kirim TabController juga
          );
        }
      ),
      floatingActionButton: Obx(
        () {
          return Visibility(
            visible: !controller.isLoading.value,
            child: _buildFloatingActionButton(context, controller.club.value),
          );
        }
      ),
    );
  }

  Widget _buildClubInfo({
    required BuildContext context
  }) {
    ClubModel? club = controller.club.value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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

                const SizedBox(width: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
                          child: Text(
                            club?.name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Visibility(
                          visible: (club?.isOwner ?? false),
                          child: GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.updateClub, arguments: club?.id),
                            child: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.date_range,
                          color: Color(0xFF6C6C6C),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.56),
                          child: Text(
                            '${club?.createdAt?.toDDMMMyyyyString()} - ${club?.province}, ${club?.country}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF6C6C6C),
                            ),
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
              club?.description ?? 'No description',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                InkWell(
                  onTap: () => Get.toNamed(AppRoutes.memberListInClub, arguments: club?.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF404040),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                        const Icon(
                          Icons.chevron_right_outlined,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () => Get.snackbar('Coming soon', 'Feature is coming soon'),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: Theme.of(context).colorScheme.onBackground,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => Get.toNamed(AppRoutes.inviteToClub, arguments: club?.id),
                  child: Icon(
                    Icons.person_add_alt_outlined,
                    color: Theme.of(context).colorScheme.onBackground,
                    size: 25,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Get.snackbar('Coming soon', 'Feature is coming soon'),
                  child: SvgPicture.asset(
                    'assets/icons/ic_share-2.svg',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, ClubModel? club) {
    return Builder(
      builder: (context) => FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimary),
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
          ).then((value) async {
            if (value == 'create_an_event') {
              // find EventActionController and hit createEventFromClub()
              final eventActionController = Get.find<EventActionController>();
              eventActionController.createEventFromClub(
                ClubMiniModel(id: club?.id, name: club?.name),
              );

              final res = await Get.toNamed(AppRoutes.eventCreate);

              if (res != null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      child: EventCardDialog(
                        eventModel: res,
                        onTap: null,
                        isAction: true,
                      ),
                    );
                  },
                );
              }
            } else if (value == 'create_a_challange') {
              Get.snackbar('Coming soon', 'Feature is coming soon');
            }
          });
        },
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      title: Text(
        'Club Details',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w300,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      pinned: true,
      floating: false,
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
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) async {
            // Handle the selection
            if (value == 'invite_friend') {
              Get.toNamed(AppRoutes.inviteToClub, arguments: controller.clubId);
            } else if (value == 'share_club') {
              Get.snackbar('Coming soon', 'Feature is coming soon');
            } else if (value == 'mute_club') {
              Get.snackbar('Coming soon', 'Feature is coming soon');
            } else if (value == 'leave_club') {
              await controller.leaveClub();
            }
          },
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'invite_friend',
                child: Text(
                  'Invite a Friend',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuItem<String>(
                value: 'share_club',
                child: Text(
                  'Share Club',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuItem<String>(
                value: 'mute_club',
                child: Text(
                  'Mute Club',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuItem<String>(
                value: 'leave_club',
                child: Text(
                  'Leave Club',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ];
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.more_horiz,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarView(BuildContext context) {
    return TabBarView(
      controller: tabBarClubController.tabBarController,
      children: [
        ClubActivityTabView(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('leaderboard will be here'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTabBar(BuildContext context) {
    return Obx(
      () {
        BorderRadiusGeometry indicatorBorderRadius;

        int currentTab = tabBarClubController.selectedIndex.value;

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
              controller: tabBarClubController.tabBarController,
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
              unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
              ),
              
              tabs: const [
                Tab(text: 'Club Activity'),
                Tab(text: 'Leaderboards'),
              ],
            ),
          ),
        );
      }
    );
  }
}