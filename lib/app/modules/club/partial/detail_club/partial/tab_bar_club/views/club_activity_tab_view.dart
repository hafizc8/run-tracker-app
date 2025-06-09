import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/club_activities_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/controllers/club_activity_tab_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/event_card.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class ClubActivityTabView extends GetView<ClubActivityTabController> {
  ClubActivityTabView({super.key});

  final eventController = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const ShimmerLoadingList(
            itemCount: 5,
            itemHeight: 100,
          );
        }

        if (controller.activities.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                SvgPicture.asset('assets/icons/ic_no_club_yet.svg', width: 140),
                const SizedBox(height: 16),
                Text(
                  'No activities yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF5C5C5C),
                        fontSize: 20,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 3),
                Text(
                  'You can create an event or create a challange',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF5C5C5C),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: controller.activities.length +
              (controller.hasReacheMax.value ? 0 : 1),
          itemBuilder: (context, index) {
            ClubActivitiesModel? activity = controller.activities[index];

            if (index == controller.activities.length) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const CircularProgressIndicator(),
                ),
              );
            }

            if (activity?.activityableType == 'event') {
              return EventCard(
                backgroundColor: Theme.of(context).colorScheme.surface,
                eventModel: activity?.event,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.socialYourPageEventDetail,
                    arguments: {'eventId': activity?.event?.id},
                  );
                  eventController.detailEvent(activity?.event?.id ?? '');
                },
              );
            } else {
              return const Text('this is card challange');
            }
          },
        );
      }),
    );
  }
}
