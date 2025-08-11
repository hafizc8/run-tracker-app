import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_footer.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_options_grid.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/share/event/controllers/share_event_controller.dart';

class ShareEventView extends GetView<ShareEventController> {
  const ShareEventView({super.key});

  @override
  Widget build(BuildContext context) {
    const eventImageUrl = 'https://res.cloudinary.com/adidas-app/image/upload/c_limit,h_2532,q_auto:good,w_2532/v1/page-assets/8/akub2mfjn0rpc2ado4xd.jpeg';
    final bool hasEventImage = eventImageUrl.isNotEmpty;

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
                        // ✨ KUNCI #1: Latar belakang dinamis ✨
                        if (hasEventImage)
                          // Lapisan 1: Gambar acara dengan filter gelap
                          Positioned.fill(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: eventImageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(color: Colors.grey[800]),
                                ),
                                // Filter gelap
                                Container(
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ],
                            ),
                          ),

                        // Lapisan 2: Background SVG dengan transparansi
                        Positioned.fill(
                          child: Opacity(
                            // Jika ada gambar acara, buat SVG ini transparan
                            opacity: hasEventImage ? 0.1 : 1.0,
                            child: SvgPicture.asset(
                              'assets/images/background_share.svg',
                              fit: BoxFit.cover,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        
                        // Lapisan Konten di atas background
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 95.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                padding: EdgeInsets.all(1.w), // Lebar border
                                decoration: BoxDecoration(
                                  border: Border.all(color: darkColorScheme.primary, width: 1),
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.0),
                                    borderRadius: BorderRadius.circular(7.w),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: '',
                                        width: 13.r,
                                        height: 13.r,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => ShimmerLoadingCircle(size: 13.r),
                                        errorWidget: (context, url, error) => Icon(
                                          size: 13.r,
                                          Icons.error,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        'Running',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Theme.of(context).colorScheme.primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 12.h),

                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                child: Text(
                                  'Nusantara Sunrise Coastal Run 2025',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white, // Teks harus putih agar shader terlihat
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),

                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                                ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                                child: Text(
                                  'Created by Tom Cruise',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),

                              Column(
                                children: [
                                  _buildPlaceholder(
                                    context: context,
                                    content: '05 June 2025\n17:00 - 19:00',
                                    icon: Container(
                                      width: 28.w,
                                      height: 28.h,
                                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                                      child: SvgPicture.asset(
                                        'assets/icons/uil_calendar.svg',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildPlaceholder(
                                    context: context,
                                    content: 'Sanur Beach, Bali',
                                    icon: Container(
                                      width: 28.w,
                                      height: 25.h,
                                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                                      child: SvgPicture.asset(
                                        'assets/icons/pin_location.svg',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildPlaceholder(
                                    context: context,
                                    content: NumberHelper().formatCurrency(250000),
                                    icon: Container(
                                      width: 28.w,
                                      height: 28.h,
                                      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                                      child: SvgPicture.asset(
                                        'assets/icons/ic_fee.svg',
                                        color: Colors.white,
                                      ),
                                    ),
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

  Widget _buildPlaceholder({required BuildContext context, required Widget icon, required String content}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 8),
        Text(
          content,
          style: GoogleFonts.poppins(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFDCDCDC), // Teks harus putih agar shader terlihat
          ),
        )
      ],
    );
  }
}