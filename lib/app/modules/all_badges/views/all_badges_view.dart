import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/all_badges/controllers/all_badges_controller.dart';
import 'package:zest_mobile/app/modules/all_badges/views/all_badges_shimmer.dart';
import 'package:zest_mobile/app/modules/all_badges/views/level_exp_bar.dart';

class AllBadgesView extends GetView<AllBadgesController> {
  const AllBadgesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.user?.name ?? '',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFFA5A5A5),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 4,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.chevron_left,
            size: 48,
            color: Color(0xFFA5A5A5),
          ),
        ),
        // ✨ Gunakan properti 'actions' untuk menambahkan widget di kanan AppBar ✨
        actions: [
          TextButton(
            onPressed: () {
              controller.showDailyGoalDialog();
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/ic_change_daily_goals.png',
                  width: 16.w,
                  height: 16.h,
                ),
                SizedBox(width: 8.w),
                ShaderMask(
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
                  child: Text(
                    'Set Your Goals',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 8.w), // Beri sedikit padding di kanan
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          if (controller.isLoadingBadges.value) {
            return const AllBadgesShimmer();
          }

          // ✨ KUNCI PERBAIKAN: Gunakan ListView.builder untuk setiap kategori ✨
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: LevelExpBar(
                  level: controller.user?.currentUserXp?.currentLevel ?? 0,
                  levelName: controller.user?.currentUserXp?.levelDetail?.animal ?? '',
                  currentExp: controller.user?.currentUserXp?.currentAmount ?? 0,
                  maxExp: controller.user?.currentUserXp?.levelDetail?.xpNeeded ?? 0,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.allCategorizedBadges.length,
                itemBuilder: (context, categoryIndex) {
                  // Ambil daftar badge untuk kategori saat ini
                  final categoryBadges = controller.allCategorizedBadges[categoryIndex];
                  // Ambil nama kategori dari item pertama (semua item dalam list ini punya kategori yang sama)
                  final categoryName = categoryBadges.first.category ?? 'Other';
              
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Tampilkan Judul Kategori ---
                        Text(
                          categoryName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFFA5A5A5),
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
              
                        // --- GridView untuk Badge di dalam Kategori Ini ---
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // 3 badge per baris
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.7, // Sesuaikan rasio aspek
                          ),
                          itemCount: categoryBadges.length,
                          itemBuilder: (context, badgeIndex) {
                            final badge = categoryBadges[badgeIndex];
                            
                            // Gunakan Opacity untuk membedakan badge yang terkunci
                            return Opacity(
                              opacity: (badge.isLocked ?? true) ? 0.3 : 1.0,
                              child: Container(
                                padding: EdgeInsets.only(right: 8.w, left: 8.w, bottom: 8.h),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Color(0xFF2E2E2E),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: badge.badgeIconUrl ?? '',
                                      fit: BoxFit.fitHeight,
                                      height: 50.h,
                                      placeholder: (context, url) => ShimmerLoadingCircle(size: 45.h),
                                      errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      badge.badgeName ?? '-',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: const Color(0xFFA5A5A5),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}