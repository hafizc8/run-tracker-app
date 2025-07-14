import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/extension/initial_profile_empty.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/challenge/controllers/create_challenge_controller.dart';

class ChallengeCreateTeamView extends GetView<ChallangeCreateController> {
  const ChallengeCreateTeamView({super.key});

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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 43.h,
            child: GradientElevatedButton(
              contentPadding: EdgeInsets.symmetric(vertical: 5.w),
              onPressed: () {
                controller.toChallengeTeam();
              },
              child: Visibility(
                visible: controller.isLoading.value,
                replacement: Text(
                  'Continue',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                child: const CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
      body: Obx(() {
        var form = controller.form.value;

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        form.teams?[index].name ?? '-',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.w700,
                              fontSize: 15.sp,
                            ),
                      ),
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: () async {},
                        child: SvgPicture.asset(
                          'assets/icons/ic_edit.svg',
                          width: 16.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  GridView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 71 / 90,
                    ),
                    itemCount: form.teams?[index].members?.length ?? 0,
                    itemBuilder: (context, i) => Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3C3C3C),
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl:
                                  form.teams?[index].members?[i].imageUrl ?? '',
                              width: 32.r,
                              height: 32.r,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  ShimmerLoadingCircle(
                                size: 32.r,
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                radius: 32.r,
                                backgroundColor:
                                    Theme.of(context).colorScheme.onBackground,
                                child: Text(
                                  (form.teams?[index].members?[i].name ?? '')
                                      .toInitials(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            form.teams?[index].members?[i].name ?? '-',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemCount: form.teams?.length ?? 0,
        );
      }),
    );
  }
}
