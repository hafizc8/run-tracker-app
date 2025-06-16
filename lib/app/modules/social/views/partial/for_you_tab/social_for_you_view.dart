import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_event.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/event_card.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SocialForYouView extends GetView<SocialController> {
  SocialForYouView({super.key});

  final eventController = Get.find<EventController>();
  final eventActionController = Get.find<EventActionController>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        eventController.load(refresh: true);
      },
      child: SingleChildScrollView(
        controller: eventController.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Events Around You',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                InkWell(
                  onTap: () => eventController.filter(),
                  child: Obx(
                    () => Badge(
                      isLabelVisible: eventController.isApplyFilter.value &&
                          (eventController.activity.value != null ||
                              eventController.location.value != null ||
                              eventController.selectedRange != null),
                      child: SvgPicture.asset(
                        'assets/icons/ic_filter.svg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Obx(() {
              if (eventController.isLoading.value &&
                  eventController.page == 1) {
                return ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return const EventShimmer();
                  },
                );
              }
              return // Card Event
                  ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: eventController.events.length +
                    (eventController.hasReacheMax.value ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index == eventController.events.length) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: const CircularProgressIndicator(),
                      ),
                    );
                  }
                  return EventCard(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    eventModel: eventController.events[index],
                    onTap: () async {
                      if (eventController.events[index].cancelledAt != null) {
                        return;
                      }
                      var result = await Get.toNamed(
                          AppRoutes.socialYourPageEventDetail,
                          arguments: {
                            'eventId': eventController.events[index].id
                          });
                      if (result != null && result is EventModel) {
                        int index = eventController.events
                            .indexWhere((element) => element.id == result.id);
                        eventController.events[index] = result.copyWith(
                          userOnEventsCount: result.userOnEvents?.length,
                        );
                      }
                    },
                  );
                },
              );
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
