import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/social_for_you_view.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/social_your_page_view.dart';
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
            _buildCustomTabBar(context),
            SizedBox(height: 24.h),
            Expanded(child: _buildTabBarView(context)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(
          left: 8.w,
          right: 8.w,
          top: 14.w,
          bottom: 14.w,
        ),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: 'ZEST+ ',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 25.sp,
                    color: darkColorScheme.primary,
                  )),
              TextSpan(
                text: 'Social',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
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
                Get.toNamed(AppRoutes.socialYourPageEventDetail,
                    arguments: {'eventId': res.id});
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
          offset: const Offset(0, 10),
          position: PopupMenuPosition.under,
          child: Container(
            width: 36.r,
            height: 36.r,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              'assets/icons/add.svg',
              width: 18.r,
              height: 18.r,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16.w, left: 10.w),
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.socialSearch),
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search,
                size: 18.r,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBarView(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
    return Obx(() {
      BorderRadiusGeometry indicatorBorderRadius;

      int currentTab = controller.selectedIndex.value;

      if (currentTab == 0) {
        indicatorBorderRadius = const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        );
      } else {
        indicatorBorderRadius = const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        );
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        height: 38.h,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(11),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
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
              Tab(text: 'Your Page'),
              Tab(text: 'For You'),
            ],
          ),
        ),
      );
    });
  }
}
