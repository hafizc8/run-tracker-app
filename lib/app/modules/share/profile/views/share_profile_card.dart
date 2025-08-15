import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/models/model/user_detail_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_footer.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

class ShareProfileCard extends StatelessWidget {
  const ShareProfileCard({super.key, required this.userDetailModel});

  final UserDetailModel userDetailModel;

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
            
                  Container(
                    padding: const EdgeInsets.all(1.5), // Ketebalan border
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: darkColorScheme.primary,
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        // Ganti dengan URL gambar profil dinamis
                        imageUrl: userDetailModel.imageUrl ?? '', 
                        width: 90.r,
                        height: 90.r,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => ShimmerLoadingCircle(size: 100.r),
                        errorWidget: (context, url, error) => Container(
                          width: 100.r, // Beri ukuran eksplisit
                          height: 100.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/empty_profile.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
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
                      userDetailModel.name ?? '',
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
                    '${userDetailModel.province}, ${userDetailModel.country}',
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
                      '${userDetailModel.bio ?? ''}',
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
                      _buildPlaceholder(context: context, title: 'Milleage', subtitle: '${userDetailModel.overallMileage ?? '0'}'),
                      _buildPlaceholder(context: context, title: 'Activity', subtitle: NumberHelper().formatNumberToKWithComma(userDetailModel.recordActivitiesCount ?? 0)),
                      _buildPlaceholder(context: context, title: 'Badge', subtitle: NumberHelper().formatNumberToKWithComma(userDetailModel.badgesCount ?? 0)),
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