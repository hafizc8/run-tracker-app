import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_footer.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

class ShareEventCard extends StatelessWidget {
  const ShareEventCard({super.key, required this.eventModel});

  final EventModel eventModel;

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
            // ✨ KUNCI #1: Latar belakang dinamis ✨
            if (eventModel.imageUrl != null)
              // Lapisan 1: Gambar acara dengan filter gelap
              Positioned.fill(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: eventModel.imageUrl ?? '',
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
                opacity: eventModel.imageUrl != null ? 0.1 : 1.0,
                child: SvgPicture.asset(
                  'assets/images/background_share.svg',
                  fit: BoxFit.cover,
                  color: eventModel.imageUrl != null ? Colors.white : null,
                ),
              ),
            ),
            
            // Lapisan Konten di atas background
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 95.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            imageUrl: eventModel.activityImageUrl ?? '',
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
                            eventModel.activity ?? '',
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
                      eventModel.title ?? '',
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
                      'Created by ${eventModel.user?.name ?? ''}',
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
                        content: '${DateFormat('d MMM yyyy').format(eventModel.datetime!)}, ${eventModel.startTime != null ? formatTime(eventModel.startTime!) : 'Start'}–${eventModel.endTime != null ? formatTime(eventModel.endTime!) : 'Finish'}',
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
                        content: '${eventModel.placeName ?? eventModel.address}, ${eventModel.province}',
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
                        content: (eventModel.price == null || eventModel.price == 0) ? 'Free' : NumberHelper().formatCurrency(eventModel.price ?? 0),
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
    );
  }

  Widget _buildPlaceholder({required BuildContext context, required Widget icon, required String content}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFDCDCDC), // Teks harus putih agar shader terlihat
            ),
          ),
        )
      ],
    );
  }

  String formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}';
}