import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/model/event_activity_model.dart';
import 'package:zest_mobile/app/core/models/model/event_location_model.dart';
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
            Text(
              'Upcoming Events Around You',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<EventActivityModel>(
                      isExpanded: true,
                      items: [
                        ...eventActionController.eventActivities.map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Obx(
                              () => Text(
                                e.value ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: eventController.activity.value ==
                                              e.value
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            'All',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: eventController.activity.value == 'All'
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          eventController.activity.value = 'All';
                          eventController.load(refresh: true);
                          return;
                        }

                        eventController.activity.value = value.value ?? '';
                        eventController.load(refresh: true);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        border: const UnderlineInputBorder(),
                        hintText: 'Activity',
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.w400,
                                ),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
                      iconSize: 24,
                      iconEnabledColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: eventController.dateController,
                      onTap: () {
                        eventController.pickDateRange(context);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        suffixIcon: Icon(
                          Icons.date_range_outlined,
                          size: 24,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        border: const UnderlineInputBorder(),
                        hintText: 'Date',
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.w400,
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<EventLocationModel>(
                      isExpanded: true,
                      items: [
                        ...eventController.eventLocations.map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Obx(
                              () => Text(
                                e.value ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: eventController.location.value ==
                                              e.value
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            'All',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: eventController.location.value == 'All'
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          eventController.location.value = 'All';
                          eventController.load(refresh: true);
                          return;
                        }

                        eventController.location.value = value.value ?? '';
                        eventController.load(refresh: true);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        border: const UnderlineInputBorder(),
                        hintText: 'Location',
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontWeight: FontWeight.w400,
                                ),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
                      iconSize: 24,
                      iconEnabledColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
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
                    eventModel: eventController.events[index],
                    onTap: () {
                      Get.toNamed(AppRoutes.socialYourPageEventDetail,
                          arguments: {
                            'eventId': eventController.events[index].id
                          });
                      eventController
                          .detailEvent(eventController.events[index].id ?? '');
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
