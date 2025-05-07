import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_chip.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/social/views/partial/search/controllers/social_search_controller.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                onChanged: (value) => controller.onSearchChanged(value),
                decoration: InputDecoration(
                  hintText: "Search for a friend",
                  suffixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: SizedBox(
                            height: 150,
                            child: ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 10),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
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
                        height:
                            150, // Atur tinggi agar horizontal scroll terlihat
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.friendsPeopleYouMayKnow.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            UserMiniModel user =
                                controller.friendsPeopleYouMayKnow[index];
                            return Card(
                              surfaceTintColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Container(
                                width: 120,
                                padding: const EdgeInsets.all(12),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CachedNetworkImage(
                                      width: 32,
                                      height: 32,
                                      imageUrl: user.imageUrl ?? '',
                                      placeholder: (context, url) =>
                                          const ShimmerLoadingCircle(size: 32),
                                      errorWidget: (context, url, error) =>
                                          const CircleAvatar(
                                        radius: 16,
                                        backgroundImage: AssetImage(
                                            'assets/images/empty_profile.png'),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      user.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    CustomChip(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.1),
                                      child: Text(
                                        'Follow',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
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
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: const CircularProgressIndicator(),
                              ),
                            );
                          }

                          UserMiniModel user = controller.friends[index];

                          return ListTile(
                            leading: CachedNetworkImage(
                              width: 32,
                              height: 32,
                              imageUrl: user.imageUrl ?? '',
                              placeholder: (context, url) =>
                                  const ShimmerLoadingCircle(size: 32),
                              errorWidget: (context, url, error) =>
                                  const CircleAvatar(
                                radius: 16,
                                backgroundImage: AssetImage(
                                    'assets/images/empty_profile.png'),
                              ),
                            ),
                            title: Text(
                              user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            trailing: CustomChip(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              child: Text(
                                'Follow',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
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
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      elevation: 4,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () => Get.back(),
      ),
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: Colors.transparent,
    );
  }

  Widget _buildCustomTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        ),
        child: Column(
          children: [
            TabBar(
              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 1,
              labelColor: Colors.white,
              unselectedLabelColor: Theme.of(context).colorScheme.primary,
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
              tabs: const [
                Tab(text: 'Friends'),
                Tab(text: 'Clubs'),
              ],
            ),
            Container(
              height: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
