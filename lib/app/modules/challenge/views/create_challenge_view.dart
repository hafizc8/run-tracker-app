import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/modules/challenge/controllers/create_challenge_controller.dart';

class ChallengeCreateView extends GetView<ChallangeCreateController> {
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(1.w), // Lebar border
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF404040),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 25,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Individual',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(1.w), // Lebar border
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF404040),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.groups_outlined,
                            size: 25,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Team',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                  // initialValue: form.title,
                  onChanged: (value) {
                    // controller.form.value = form.copyWith(
                    //   title: value,
                    //   errors: form.errors,
                    //   field: 'title',
                    // );
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Title',
                    // errorText: form.errors?['title'],
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start Date',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.text,
                  // initialValue: form.title,
                  onChanged: (value) {
                    // controller.form.value = form.copyWith(
                    //   title: value,
                    //   errors: form.errors,
                    //   field: 'title',
                    // );
                  },
                  decoration: InputDecoration(
                    hintText: 'Start Date',
                    // errorText: form.errors?['title'],
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'Challenge Mode',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                  ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.only(top: 12.w, bottom: 12.w, right: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Radio(
                          value: true, groupValue: true, onChanged: (value) {}),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'First to Finish',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.sp,
                                  ),
                            ),
                            Text(
                              'Be the first to complete the challenge',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Color(0xFF636363),
                                  ),
                            ),
                            SizedBox(height: 16.h),
                            Visibility(
                              visible: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Target Steps',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    cursorColor: Colors.white,
                                    keyboardType: TextInputType.text,
                                    // initialValue: form.title,
                                    onChanged: (value) {
                                      // controller.form.value = form.copyWith(
                                      //   title: value,
                                      //   errors: form.errors,
                                      //   field: 'title',
                                      // );
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter target steps',
                                      // errorText: form.errors?['title'],
                                    ),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.only(top: 12.w, bottom: 12.w, right: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Radio(
                          value: true, groupValue: true, onChanged: (value) {}),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Timed Challenge',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13.sp,
                                  ),
                            ),
                            Text(
                              'Achieve the goal within a set duration',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Color(0xFF636363),
                                  ),
                            ),
                            SizedBox(height: 16.h),
                            Visibility(
                              visible: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'End Date',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextFormField(
                                    cursorColor: Colors.white,
                                    keyboardType: TextInputType.text,
                                    // initialValue: form.title,
                                    onChanged: (value) {
                                      // controller.form.value = form.copyWith(
                                      //   title: value,
                                      //   errors: form.errors,
                                      //   field: 'title',
                                      // );
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Choose Date',
                                      // errorText: form.errors?['title'],
                                    ),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
