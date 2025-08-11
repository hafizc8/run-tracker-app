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
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchNotifications(refresh: true);
        },
        child: SingleChildScrollView(
          controller: controller.notificationScrollController,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              children: [
                // Header
                Obx(
                  () {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Notifications (${controller.notificationCount.value})',
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: darkColorScheme.primary,
                            ),
                          ),
                          (controller.isLoadingReadAll.value)
                          ? const CircularProgressIndicator()
                          : TextButton(
                            onPressed: () {
                              controller.readNotification();
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
                    );
                  }
                ),
                
                Obx(
                  () {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == controller.notifications.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final notification = controller.notifications[index];
                        return GestureDetector(
                          onTap: () {
                            controller.readNotification(notification: notification);
                          },
                          child: Container(
                            color: darkColorScheme.background,
                            child: NotificationItem(
                              notification: notification,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: 0.h,
                      ),
                      itemCount: controller.notifications.length + (controller.hasReacheMaxNotification.value ? 0 : 1),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}