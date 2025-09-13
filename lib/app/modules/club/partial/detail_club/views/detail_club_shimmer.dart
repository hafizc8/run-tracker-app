import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';

class DetailClubShimmer extends StatelessWidget {
  const DetailClubShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // Base and highlight colors for the shimmer effect
    final baseColor = Colors.grey.shade800;
    final highlightColor = Colors.grey.shade700;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(), // Disable scroll on shimmer
        slivers: [
          // Shimmer for the SliverAppBar
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: Icon(Icons.chevron_left, size: 35, color: baseColor),
            title: Container(
              height: 20.h,
              width: 120.w,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.more_horiz, color: baseColor),
              ),
            ],
          ),

          // Shimmer for the Club Info Card
          SliverToBoxAdapter(
            child: _buildClubInfoShimmer(context, baseColor),
          ),

          // Shimmer for the Tab Bar
          SliverPersistentHeader(
            delegate: _SliverShimmerTabBarDelegate(
              tabBar: _buildTabBarShimmer(context, baseColor),
            ),
            pinned: true,
          ),

          // Shimmer for the TabBarView content
          const SliverFillRemaining(
            child: ShimmerLoadingList(
              itemCount: 5,
              itemHeight: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClubInfoShimmer(BuildContext context, Color baseColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 32.5.r, backgroundColor: Colors.white),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 18.h,
                    width: 150.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    height: 14.h,
                    width: 200.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Container(
            height: 12.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            height: 35.h,
            width: 150.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11.r),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarShimmer(BuildContext context, Color baseColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 38.h,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Delegate helper for the shimmer tab bar
class _SliverShimmerTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverShimmerTabBarDelegate({required this.tabBar});
  final Widget tabBar;

  @override
  double get minExtent => 38.h;
  @override
  double get maxExtent => 38.h;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverShimmerTabBarDelegate oldDelegate) {
    return false;
  }
}
