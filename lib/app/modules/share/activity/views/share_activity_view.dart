import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_footer.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_options_grid.dart';
import 'package:zest_mobile/app/modules/share/activity/controllers/share_activity_controller.dart';

class ShareActivityView extends GetView<ShareActivityController> {
  const ShareActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: darkColorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
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

                              // TODO: change to rectangle google map
                              Container(
                                width: double.infinity,
                                height: 160.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  image: const DecorationImage(
                                    image: AssetImage('assets/images/map.png'),
                                    fit: BoxFit.cover,
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
                                  'Morning Walk',
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
                                'Jakarta, Indonesia',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  color: const Color(0xFFB6B6B6),
                                ),
                              ),
                              SizedBox(height: 16.h),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildPlaceholder(
                                    context: context,
                                    svgIconPath: 'assets/icons/ic_run_white.svg',
                                    text: '21,00 km',
                                  ),
                                  _buildPlaceholder(
                                    context: context,
                                    svgIconPath: 'assets/icons/ic_time_white.svg',
                                    text: '10:59',
                                  ),
                                  _buildPlaceholder(
                                    context: context,
                                    svgIconPath: 'assets/icons/ic_coin_white.svg',
                                    text: '2.500',
                                  ),
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

            SizedBox(height: 24.h),
            ShareOptionsGrid(
              onOptionTap: (String label) {
                // Panggil fungsi di controller Anda
                // controller.shareTo(label);
                print("Sharing to: $label");
              },
            ),
            SizedBox(height: 24.h),
          ],
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

  Widget _buildPlaceholder({required BuildContext context, required String svgIconPath, required String text}) {
    return Row(
      children: [
        SvgPicture.asset(
          svgIconPath,
          height: 20.h,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFDCDCDC), // Teks harus putih agar shader terlihat
          ),
        ),
      ],
    );
  }
}