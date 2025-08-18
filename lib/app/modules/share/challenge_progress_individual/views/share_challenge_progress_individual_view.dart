import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_options_grid.dart';
import 'package:zest_mobile/app/modules/share/challenge_progress_individual/controllers/share_challenge_progress_individual_controller.dart';
import 'package:zest_mobile/app/modules/share/challenge_progress_individual/views/share_challenge_progress_individual_card.dart';

class ShareChallengeProgressIndividualView extends GetView<ShareChallengeProgressIndividualController> {
  const ShareChallengeProgressIndividualView({super.key});

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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: darkColorScheme.primary, width: 1),
                    borderRadius: BorderRadius.circular(18.r),
                    color: darkColorScheme.surface,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: Screenshot(
                      controller: controller.screenshotController,
                      child: ShareChallengeProgressIndividualCard(
                        challengeModel: controller.challengeData.value!,
                      ),
                    ),
                  ),
                ),
            
                SizedBox(height: 24.h),
                ShareOptionsGrid(
                  onOptionTap: (String label) {
                    controller.shareTo(label);
                  },
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