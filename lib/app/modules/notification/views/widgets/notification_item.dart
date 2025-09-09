import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/models/enums/notification_type_enum.dart';
import 'package:zest_mobile/app/core/models/model/notification_model.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/modules/notification/controllers/notification_controller.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';

class NotificationItem extends GetView<NotificationController> {
  final NotificationModel notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Tentukan tipe notifikasi yang pesannya inline
    final bool isInlineMessage = notification.type == NotificationTypeEnum.userFollowing.name || notification.type == NotificationTypeEnum.postLike.name;
    final bool isFollowBackAction = notification.type == NotificationTypeEnum.userFollowing.name;
    final String addedDescription = (notification.type == NotificationTypeEnum.eventInvite.name)
      ? (notification.data?['event']['title'] ?? '') 
      : (
        notification.type == NotificationTypeEnum.challangeInvite.name
        ? (notification.data?['challange']['title'] ?? '')
        : ''
      );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon Lonceng/Profil
          Container(
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              notification.readAt != null
              ? 'assets/icons/ic_notification_read.svg'
              : 'assets/icons/ic_notification.svg',
              width: 30.r,
              height: 30.r,
            ),
          ),
          SizedBox(width: 16.w),
          
          // ✨ KUNCI PERBAIKAN: Tata letak konten diubah menjadi Row ✨
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Bagian teks akan mengambil ruang yang tersisa
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isInlineMessage)
                        // Layout untuk NEW_FOLLOWER dan ACTIVITY_LIKE
                        RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: (notification.readAt != null) ? const Color(0xFF757575) : darkColorScheme.onBackground,
                            ),
                            children: [
                              TextSpan(
                                text: notification.data?['title'] ?? '',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                  color: (notification.readAt != null) ? const Color(0xFF757575) : darkColorScheme.onBackground,
                                ),
                              ),
                              TextSpan(text: ' ${notification.data?['description']}'),
                            ],
                          ),
                        )
                      else
                        // Layout default untuk tipe notifikasi lainnya
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.data?['title'] ?? '',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp,
                                color: (notification.readAt != null) ? const Color(0xFF757575) : darkColorScheme.onBackground,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "${notification.data?['description'] ?? ''}$addedDescription",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: (notification.readAt != null) ? const Color(0xFF757575) : darkColorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),

                      // date
                      SizedBox(height: 10.h),
                      Text(
                        '${notification.createdAt?.toMMMddyyyyhhmmaString()}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                          color: (notification.readAt != null) ? const Color(0xFF757575) : const Color(0xFF6C6C6C),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Tombol Follow Back (hanya muncul jika diperlukan)
                if (isFollowBackAction) ...[
                  SizedBox(width: 8.w),
                  notification.data?['user']['is_following'] == 0
                  ? SizedBox(
                    width: 100.w,
                    height: 28.h,
                    child: GradientOutlinedButton(
                      contentPadding: const EdgeInsets.all(0),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      onPressed: () {
                        controller.followBack(notification.data?['user']['id']);
                      },
                      child: Text(
                        'Follow Back',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ) : const SizedBox(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}