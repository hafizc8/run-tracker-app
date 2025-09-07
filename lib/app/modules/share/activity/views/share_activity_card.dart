import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_footer.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_rectangle.dart';

class ShareActivityCard extends StatelessWidget {
  const ShareActivityCard({super.key, required this.postModel, required this.distanceInFormat});

  final PostModel postModel;
  final String distanceInFormat;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                mainAxisSize: MainAxisSize.min,
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

                  _buildMapPlaceholder(postModel.galleryMap),
                  SizedBox(height: 16.h),

                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    child: Text(
                      postModel.title ?? '',
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
                    postModel.district ?? '',
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
                        text: distanceInFormat,
                      ),
                      _buildPlaceholder(
                        context: context,
                        svgIconPath: 'assets/icons/ic_time_white.svg',
                        text: NumberHelper().formatDuration(int.parse((postModel.recordActivity?.lastRecordActivityLog?.pace ?? 0.0).toStringAsFixed(0))),
                      ),
                      _buildPlaceholder(
                        context: context,
                        svgIconPath: 'assets/icons/ic_coin_white.svg',
                        text: postModel.recordActivity?.coin ?? '0',
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

  Widget _buildMapPlaceholder(Gallery? galleryMap) {
    // return StaticRouteMap(
    //   activityLogs: recordActivity?.recordActivityLogs ?? [],
    //   height: 200.h,
    // );
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: CachedNetworkImage(
        imageUrl: galleryMap?.url ?? '',
        width: double.infinity,
        height: 200.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => ShimmerLoadingRectangle(height: 200.h),
        errorWidget: (context, url, error) => _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.grey.shade300,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 64.r, color: Colors.grey),
                SizedBox(height: 8.h),
                const Text('Maps not available', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}