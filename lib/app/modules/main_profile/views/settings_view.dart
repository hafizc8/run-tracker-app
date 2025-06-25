import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/main_profile/controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Color(0xFFA5A5A5),
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_unit.svg',
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    'Unit',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ),
              ],
            ),
            trailing: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFA2FF00),
                  Color(0xFF00FF7F),
                ],
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Text(
                'Kilometers',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () => controller.showNotifDialog(context),
            title: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_notif.svg',
                ),
                SizedBox(width: 5.w),
                Text(
                  'Notification',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () => controller.showPrivacyPolicyDialog(context),
            title: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_privacy_policy.svg',
                ),
                SizedBox(width: 5.w),
                Text(
                  'Privacy Policy',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_tnc.svg',
                ),
                SizedBox(width: 5.w),
                Text(
                  'Terms & Conditions',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Color(0xFF4A4A4A),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () => controller.showLogoutDialog(context),
            title: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_logout.svg',
                ),
                SizedBox(width: 5.w),
                Text(
                  'Logout',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 37.h),
          const Divider(
            color: Color(0xFF4A4A4A),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Text(
              "Version ${controller.appVersion.value ?? '-'}",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
        ],
      ),
    );
  }
}
