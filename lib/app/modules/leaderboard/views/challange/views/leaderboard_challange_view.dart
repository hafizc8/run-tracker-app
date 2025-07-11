import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/leaderboard/views/challange/views/widgets/leaderboard_challange_card.dart';

import '../controllers/leaderboard_challange_controller.dart';

class LeaderboardChallangeView extends GetView<LeaderboardChallangeController> {
  LeaderboardChallangeView({super.key});

  @override
  final controller = Get.put(LeaderboardChallangeController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return LeaderboardChallengeCard(
                challengeType: 'Team',
                title: 'Office Run Challenge',
                mode: 'Timed Challenge',
                startDate: DateTime(2025, 5, 1),
                endDate: DateTime(2025, 5, 31),
                onTap: () {
                  print('Card tapped!');
                },
              );
            }
          ),
        ],
      ),
    );
  }
}