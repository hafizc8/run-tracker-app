import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_footer.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_options_grid.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/share/profile/controllers/share_profile_controller.dart';
import 'package:zest_mobile/app/modules/share/profile/views/share_profile_shimmer.dart';

class ShareProfileView extends GetView<ShareProfileController> {
  const ShareProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: darkColorScheme.surface,
      body: SingleChildScrollView(
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const ShareProfileShimmer();
            }

            return Column(
              children: [
                Screenshot(
                  controller: controller.screenshotController,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Lapisan 1: Container utama dengan border dan background SVG
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: darkColorScheme.primary, width: 1),
                          borderRadius: BorderRadius.circular(18.r),
                          color: darkColorScheme.surface,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18.r),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: SvgPicture.asset(
                                  'assets/images/background_share.svg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              
                              // Lapisan Konten di atas background
                              Padding(
                                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 82.h),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: SvgPicture.asset(
                                          'assets/images/zest_green.svg',
                                          height: 25.h,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 42.h),
                              
                                    Container(
                                      padding: const EdgeInsets.all(1.5), // Ketebalan border
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: darkColorScheme.primary,
                                      ),
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          // Ganti dengan URL gambar profil dinamis
                                          imageUrl: controller.userDetail.value?.imageUrl ?? '', 
                                          width: 90.r,
                                          height: 90.r,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => ShimmerLoadingCircle(size: 100.r),
                                          errorWidget: (context, url, error) => CircleAvatar(
                                            radius: 50.r,
                                            backgroundImage: const AssetImage('assets/images/empty_profile.png'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                              
                                    ShaderMask(
                                      shaderCallback: (bounds) => const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                                      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                      child: Text(
                                        controller.userDetail.value?.name ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white, // Teks harus putih agar shader terlihat
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                              
                                    Text(
                                      '${controller.userDetail.value?.province}, ${controller.userDetail.value?.country}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        color: const Color(0xFFB6B6B6),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                              
                                    ShaderMask(
                                      shaderCallback: (bounds) => const LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                                      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                      child: Text(
                                        '${controller.userDetail.value?.bio ?? ''}',
                                        maxLines: 4,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                          color: Colors.white, // Teks harus putih agar shader terlihat
                                        ),
                                      ),
                                    ),
                              
                                    SizedBox(height: 24.h),
                              
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildPlaceholder(context: context, title: 'Milleage', subtitle: '${controller.userDetail.value?.overallMileage ?? '0'}'),
                                        _buildPlaceholder(context: context, title: 'Activity', subtitle: '---'),
                                        _buildPlaceholder(context: context, title: 'Badge', subtitle: '${controller.userDetail.value?.badgesCount ?? '0'}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Container "Powered by" di bagian bawah
                              const ShareFooter(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            
                SizedBox(height: 24.h),
                ShareOptionsGrid(
                  onOptionTap: (String label) {
                    // Panggil fungsi di controller Anda
                    // controller.shareTo(label);
                    print("Sharing to: $label");
                    controller.shareTo(label);
                  },
                ),
                SizedBox(height: 24.h),
              ],
            );
          }
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.onBackground,
          size: 35,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Share',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9B9B9B),
        ),
      ),
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: darkColorScheme.surface,
      backgroundColor: darkColorScheme.surface,
    );
  }

  Widget _buildPlaceholder({required BuildContext context, required String title, required String subtitle}) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 11.sp,
            color: const Color(0xFF9B9B9B),
          ),
        ),
        const SizedBox(height: 4),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white, // Teks harus putih agar shader terlihat
            ),
          ),
        ),
      ],
    );
  }
}