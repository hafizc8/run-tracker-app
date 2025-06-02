import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/card_activity.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_chip.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/main_profile/partials/profile/controllers/profile_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  bottom: 16,
                  right: 16,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 16,
                      ),
                      width: double.infinity,
                      height: 256,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: CachedNetworkImage(
                                            imageUrl: controller
                                                    .user.value?.imageUrl ??
                                                '',
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const ShimmerLoadingCircle(
                                                    size: 50),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const CircleAvatar(
                                              radius: 32,
                                              backgroundImage: AssetImage(
                                                  'assets/images/empty_profile.png'),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.58),
                                              child: Text(
                                                controller.user.value?.name ?? '-',
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.copyWith(
                                                      color: Theme.of(
                                                              context)
                                                          .colorScheme
                                                          .onBackground,
                                                    ),
                                              ),
                                            ),
                                            ConstrainedBox(
                                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.58),
                                              child: Text(
                                                '${controller.user.value?.province ?? '-'}, ${controller.user.value?.country ?? '-'}',
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontSize: 13,
                                                      color: const Color(0xFF6C6C6C)
                                                    ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.58,
                                    ),
                                    child: Text(
                                      controller.user.value?.bio ?? 'No bio',
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontSize: 12,
                                          ),
                                    ),
                                  ),
                                  const Spacer(),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 200,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text('Following'),
                                            Text(
                                              '${controller.user.value?.followingCount ?? 0}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('Followers'),
                                            Text(
                                              '${controller.user.value?.followersCount ?? 0}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text('Clubs'),
                                            Text(
                                              '${controller.user.value?.clubsCount ?? 0}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              // IconButton(
                              //   icon: const Icon(Icons.settings_outlined),
                              //   onPressed: () =>
                              //       Get.toNamed(AppRoutes.settings),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: InkWell(
                        onTap: () => Get.snackbar('Coming Soon', 'Feature coming soon'),
                        child: SvgPicture.asset(
                          'assets/icons/ic_share-2.svg',
                          width: 26,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -5,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            'assets/images/image.png',
                            fit: BoxFit.cover,
                            width: 189,
                          ),
                          Positioned(
                            bottom: 10,
                            right: 25,
                            child: Row(
                              children: [
                                Text(
                                  'Level 4',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'The Snail',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Badges',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Color(0xFFA5A5A5),
                        ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.badges),
                    child: Row(
                      children: [
                        Obx(
                          () => Text(
                            '${controller.user.value?.badgesCount ?? 0}',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: Color(0xFFA5A5A5),
                                ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFFA5A5A5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: (controller.user.value?.badges ?? [])
                    .map(
                      (e) => Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, bottom: 12),
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFF2E2E2E),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: e.badgeIconUrl ?? '',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const ShimmerLoadingCircle(size: 50),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    radius: 32,
                                    backgroundImage: AssetImage(
                                        'assets/images/empty_profile.png'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                e.badgeName ?? '-',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    SvgPicture.asset('assets/icons/overall_mileage.svg'),
                    const SizedBox(width: 8),
                    Text(
                      'Overall Mileage',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ]),
                  Text(
                    '${controller.user.value?.overallMileage ?? 0} km',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Activity',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const CardActivity(),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => Get.toNamed(AppRoutes.activity),
                      child: Text(
                        'See All',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
