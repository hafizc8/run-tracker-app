import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_options_grid.dart';
import 'package:zest_mobile/app/modules/share/badges/controllers/share_badges_controller.dart';
import 'package:zest_mobile/app/modules/share/badges/views/share_badges_card.dart';

class ShareBadgesView extends GetView<ShareBadgesController> {
  const ShareBadgesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: darkColorScheme.surface,
      body: SingleChildScrollView(
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        
            return Column(
              children: [
                ShareBadgesCard(
                  title: controller.title,
                  description: controller.description,
                  imageUrl: controller.imageUrl,
                ),
            
                SizedBox(height: 24.h),
                ShareOptionsGrid(
                  onOptionTap: (String label) async {
                    await controller.shareTo(label);
                  },
                  options: const [
                    ShareOption.whatsapp,
                    ShareOption.igStory,
                    ShareOption.igFeed,
                    ShareOption.x,
                    ShareOption.download,
                  ],
                ),
                SizedBox(height: 24.h),
              ],
            );
          }
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
}