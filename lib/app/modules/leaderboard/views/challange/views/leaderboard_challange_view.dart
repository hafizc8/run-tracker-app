import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

import '../controllers/leaderboard_challange_controller.dart';
import 'package:zest_mobile/app/core/shared/widgets/card_challenge.dart';

class LeaderboardChallangeView extends GetView<LeaderboardChallangeController> {
  LeaderboardChallangeView({super.key});

  @override
  final controller = Get.put(LeaderboardChallangeController());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.getChallenges(refresh: true);
      },
      child: SingleChildScrollView(
        controller: controller.challengeController,
        child: Column(
          children: [
            Obx(
              () {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == controller.challenges.length) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final challenge = controller.challenges[index];
                    return GestureDetector(
                      onTap: () async {
                        if (challenge.cancelledAt != null) return;
                        var res = await Get.toNamed(
                          AppRoutes.challengedetails,
                          arguments: {
                            "challengeId": challenge.id,
                          },
                        );
                        if (res != null) {
                          int index = controller.challenges.indexWhere((e) => e.id == challenge.id);
                          controller.challenges[index] = res;
                        }
                      },
                      child: CardChallenge(
                        challengeModel: challenge,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 16.h,
                  ),
                  itemCount: controller.challenges.length + (controller.hasReacheMaxChallenge.value ? 0 : 1),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}