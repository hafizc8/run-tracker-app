import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/modules/challenge/controllers/challenge_controller.dart';

class ChallengeCreateView extends GetView<ChallangeController> {
  const ChallengeCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create a Challenge',
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
      bottomNavigationBar: Obx(
        () => SizedBox(
          height: 43.h,
          child: GradientElevatedButton(
            contentPadding: EdgeInsets.symmetric(vertical: 5.w),
            onPressed: controller.isLoading.value
                ? null
                : controller.isLoading.value
                    ? null
                    : () {
                        controller.storeChallenge();
                      },
            child: Visibility(
              visible: controller.isLoading.value,
              replacement: Text(
                'Create Challenge',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              child: const CircularProgressIndicator(),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('Challenge'),
      ),
    );
  }
}
