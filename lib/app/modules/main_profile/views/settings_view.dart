import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.chevron_left,
            size: 48,
            color: Color(0xFFA5A5A5),
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.gauge,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'Units of Measurements',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
              ],
            ),
            trailing: Text(
              'Kilometers',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          ListTile(
            onTap: () => controller.showNotifDialog(context),
            title: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.bell,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  'Notification',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () => controller.showPrivacyPolicyDialog(context),
            title: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  'Privacy Policy',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  'Terms & Conditions',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () => controller.showLogoutDialog(context),
            title: Row(
              children: [
                Icon(
                  Icons.logout,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 5),
                Text(
                  'Logout',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
