import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_chip.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/main_profile/widgets/custom_tab_bar/views/custom_tab_bar_view.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/main_profile_controller.dart';

class MainProfileView extends GetView<ProfileMainController> {
  const MainProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          )
        ],
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
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Stack(
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
                                  imageUrl:
                                      controller.user.value?.imageUrl ?? '',
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
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ConstrainedBox(
                                        constraints:
                                            const BoxConstraints(maxWidth: 150),
                                        child: Text(
                                          controller.user.value?.name ?? '-',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () async {
                                          var res = await Get.toNamed(
                                              AppRoutes.profileEdit);
                                          if (res != null) {
                                            controller.user.value = res;
                                          }
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 150),
                                    child: Text(
                                      '${controller.user.value?.province ?? '-'}, ${controller.user.value?.country ?? '-'}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.user.value?.bio ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: [
                            const CustomChip(
                              child: Text('10k Following'),
                            ),
                            const CustomChip(
                              child: Text('10k Following'),
                            ),
                            const CustomChip(
                              child: Text('10 Clubs'),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.shareFromSquare,
                                size: 20.0,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 130,
                        width: 130,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/star_profile.png',
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 5,
                              right: 15,
                              child: Image.asset(
                                height: 65,
                                width: 65,
                                'assets/images/keong.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
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
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.badges),
                    child: Row(
                      children: [
                        Text(
                          '20',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CarouselSlider(
              items: controller.items.map((item) {
                return Container(
                  width: 125,
                  height: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Placeholder(fallbackHeight: 40, fallbackWidth: 100),
                      const SizedBox(height: 5),
                      Text(
                        item,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
              carouselController: controller.controllerSlider,
              options: CarouselOptions(
                height: 100,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                disableCenter: false,
                padEnds: false,
                viewportFraction: 125 / MediaQuery.of(context).size.width,
                onPageChanged: (index, reason) {
                  controller.activeIndex.value = index;
                },
              ),
            ),
            Center(
              child: Obx(
                () => AnimatedSmoothIndicator(
                  activeIndex: (controller.activeIndex.value / 3).floor(),
                  count: (controller.items.length / 3).ceil(),
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Theme.of(context).primaryColor,
                  ),
                  onDotClicked: (index) =>
                      controller.controllerSlider.animateToPage(index),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    SvgPicture.asset('assets/icons/ic_distance.svg'),
                    const SizedBox(width: 8),
                    Text(
                      'Distance',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ]),
                  Text(
                    '8 km',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomTabBar(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
