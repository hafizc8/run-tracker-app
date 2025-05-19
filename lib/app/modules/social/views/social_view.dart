import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/social_for_you_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_view.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';
import '../controllers/social_controller.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';

class SocialView extends GetView<SocialController> {
  const SocialView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(height: 16),
            _buildCustomTabBar(context),
            const SizedBox(height: 8),
            Expanded(child: _buildTabBarView(context)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Social',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: Colors.transparent,
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            // Handle the selection
            if (value == 'create_event') {
              // Handle Create Event action
            } else if (value == 'create_club') {
              Get.toNamed(AppRoutes.createClub);
            }
          },
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'create_event',
                child: Text(
                  'Create an Event',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuItem<String>(
                value: 'create_club',
                child: Text(
                  'Create a Club',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ];
          },
          child: Row(
            children: [
              Icon(Icons.add,
                  size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 3),
              Text('CREATE',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
        ),
        Container(
          height: 24,
          width: 1,
          color: Colors.black.withOpacity(0.2),
          margin: const EdgeInsets.symmetric(horizontal: 8),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 10),
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.socialSearch),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search,
                  size: 18, color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
      ],
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
                color: lightColorScheme.primary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 1,
              labelColor: Colors.white,
              unselectedLabelColor: lightColorScheme.primary,
              labelStyle: Theme.of(context).textTheme.bodyLarge,
              unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
              tabs: const [
                Tab(text: 'Your Page'),
                Tab(text: 'For You'),
              ],
            ),
            Container(height: 1, color: lightColorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: TabBarView(
        children: [
          SocialYourPageView(),
          const SocialForYouView(),
        ],
      ),
    );
  }
}
