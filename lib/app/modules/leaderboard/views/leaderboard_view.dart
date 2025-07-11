import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/leaderboard/controllers/leaderboard_controller.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/challange/views/leaderboard_challange_view.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/top_walkers/views/leaderboard_top_walkers_tab_view.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'Leaderboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 17.sp
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            SizedBox(height: 8.h),
            _buildCustomTabBar(context),
            SizedBox(height: 24.h),
            Expanded(child: _buildTabBarView(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarView(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TabBarView(
        controller: controller.tabBarController,
        children: [
          LeaderboardTopWalkersTabView(),
          LeaderboardChallangeView(),
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
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00FF7F),
              Color(0xFFA2FF00),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TabBar(
              controller: controller.tabBarController,
              indicator: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFA2FF00),
                    Color(0xFF00FF7F),
                  ],
                ),
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
              tabs: controller.tabs.map((element) {
                final int index = controller.tabs.indexOf(element);
                bool isSelected = index == currentTab;
                if (isSelected) {
                  return Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _getIconTab(index, isSelected, context),
                        SizedBox(width: 7.w),
                        Text(
                          element,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Tab(
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFA2FF00),
                        Color(0xFF00FF7F),
                      ],
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _getIconTab(index, isSelected, context),
                        SizedBox(width: 7.w),
                        Text(
                          element,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }

  Widget _getIconTab(int index, bool isSelected, BuildContext context) {
    final String assetName = (index == 0)
        ? 'assets/icons/ic_top_walkers_tab.svg'
        : 'assets/icons/ic_challange_tab.svg';

    // Jika tab sedang dipilih, tampilkan ikon dengan warna solid
    if (isSelected) {
      return SvgPicture.asset(
        assetName,
        height: 23,
        // Gunakan colorFilter untuk memberi warna pada SVG
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onPrimary,
          BlendMode.srcIn,
        ),
      );
    }

    // Jika tab tidak dipilih, bungkus ikon dengan ShaderMask-nya sendiri
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Color(0xFFA2FF00),
          Color(0xFF00FF7F),
        ],
      ).createShader(bounds),
      child: SvgPicture.asset(
        assetName,
        height: 23,
        // PENTING: SVG harus diberi warna solid (putih)
        // agar shader bisa diterapkan di atasnya.
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}