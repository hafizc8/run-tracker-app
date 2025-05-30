import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/social_for_you_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_view.dart';
import 'package:zest_mobile/app/modules/social/widgets/event_card_dialog.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../controllers/social_controller.dart';

class SocialView extends GetView<SocialController> {
  const SocialView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(context),
        backgroundColor: Theme.of(context).colorScheme.background,
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
      title: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
          children: <TextSpan>[
            const TextSpan(text: 'ZEST+ '),
            TextSpan(
              text: 'Social',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) async {
            // Handle the selection
            if (value == 'create_event') {
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
                    });
              }
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
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: 18, 
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 10),
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.socialSearch),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search,
                size: 18, 
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: TabBarView(
        controller: controller.tabBarController,
        children: [
          SocialYourPageView(),
          SocialForYouView(),
        ],
      ),
    );
  }

  Widget _buildCustomTabBar(BuildContext context) {
    return Obx(
      () {
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
              unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
              ),
              
              tabs: const [
                Tab(text: 'Your Page'),
                Tab(text: 'For You'),
              ],
            ),
          ),
        );
      }
    );
  }
}

