import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:zest_mobile/app/core/extension/initial_profile_empty.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/challenge/controllers/create_challenge_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 43.h,
              child: GradientOutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 5.w),
                onPressed: () {
                  controller.addTeam();
                },
                child: Text(
                  'Add A New Team',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Obx(
              () => SizedBox(
                height: 43.h,
                child: GradientElevatedButton(
                  contentPadding: EdgeInsets.symmetric(vertical: 5.w),
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.storeChallenge(isTeam: true);
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
          ],
        ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (form.teams?[index].isEdit == true)
                              Expanded(
                                child: TextFormField(
                                  initialValue: form.teams?[index].name,
                                  decoration: const InputDecoration(
                                      labelText: 'Edit Team Name'),
                                  onChanged: (value) =>
                                      controller.updateTempName(index, value),
                                ),
                              )
                            else
                              Text(
                                form.teams?[index].name ?? '-',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.sp,
                                    ),
                              ),
                            SizedBox(width: 12.w),
                            if (!(form.teams?[index].isEdit ?? false))
                              GestureDetector(
                                onTap: () =>
                                    controller.toggleEditTeam(index, true),
                                child: SvgPicture.asset(
                                  'assets/icons/ic_edit.svg',
                                  width: 16.w,
                                ),
                              )
                            else
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => controller.saveEdit(index),
                                    child: const Icon(Icons.check,
                                        color: Colors.green),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () => controller.cancelEdit(index),
                                    child: const Icon(Icons.close,
                                        color: Colors.grey),
                                  ),
                                  const SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () {
                                      controller.deleteTeam(index,
                                          form.teams?[index].isOwner ?? false);
                                    },
                                    child: const Icon(
                                      Icons.delete_outlined,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  GridView(
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
                    children: [
                      ...(List.generate(
                          controller.form.value.teams?[index].members?.length ??
                              0, (i) {
                        final e =
                            controller.form.value.teams?[index].members?[i];

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AspectRatio(
                              aspectRatio: 71 / 90,
                              child: Container(
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
                                        imageUrl: e?.imageUrl ?? '',
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
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          child: Text(
                                            (e?.name ?? '').toInitials(),
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
                                      e?.name ?? '-',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (controller.userId != e?.id)
                              Positioned(
                                top: -8.h,
                                right: -8.w,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.removeMemberFromTeam(index, i);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      })),
                      GestureDetector(
                        onTap: () async {
                          if ((controller.form.value.teams?[index].members
                                      ?.length ??
                                  0) >=
                              10) {
                            Get.snackbar(
                              'Warning!',
                              'You cannot add more than 10 members',
                              backgroundColor: Colors.yellow,
                              colorText: Colors.black,
                            );
                            return;
                          }

                          var res = await Get.toNamed(
                            AppRoutes.challengeInviteFriend,
                          );
                          if (res != null) {
                            controller.addMembersToTeam(
                                index, res as List<User>);
                            ();
                          }
                        },
                        child: AspectRatio(
                          aspectRatio: 71 / 90,
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFA2FF00),
                                  Color(0xFF00FF7F),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(11.r),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: Theme.of(context).colorScheme.background,
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                width: 24.r,
                                height: 24.r,
                                'assets/icons/follow_gradient.svg',
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
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
