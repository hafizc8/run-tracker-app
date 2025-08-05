import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/modules/notification/views/widgets/notification_item.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFFA5A5A5),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 4,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.chevron_left,
              color: Color(0xFFA5A5A5),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          // TODO: Ganti ini dengan shimmer effect kustom jika diinginkan
          return const Center(child: CircularProgressIndicator());
        }
        
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications (${controller.notifications.length})',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: darkColorScheme.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Tambahkan fungsi untuk membaca semua notifikasi
                    },
                    child: Text(
                      'Read all',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: darkColorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Daftar Notifikasi
            ...controller.notifications.map((notification) {
              return NotificationItem(notification: notification);
            }).toList(),
          ],
        );
      }),
    );
  }
}