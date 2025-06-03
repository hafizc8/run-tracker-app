import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_detail_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class EventDetailCard extends GetView<EventDetailController> {
  EventDetailCard({super.key, required this.event});
  final EventModel? event;
  final eventActionController = Get.find<EventActionController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  event?.title ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Icon(
                Icons.share_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Image
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.grey.shade300,
                child: CachedNetworkImage(
                  imageUrl: event?.imageUrl ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: const SizedBox.shrink(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Image Placeholder',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // title
          Row(
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: event?.user?.imageUrl ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: const SizedBox.shrink(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ORGANIZED BY',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onTertiary)),
                  Text('[${event?.user?.name}]',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          // description
          Text(
            event?.description ?? '-',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem(
                context,
                icon: Icons.track_changes_outlined,
                title: 'QUOTA',
                subtitle: event?.quota.toString() ?? '-',
              ),
              const SizedBox(height: 16),
              _buildInfoItem(
                context,
                icon: Icons.date_range_outlined,
                title: 'PERIOD',
                subtitle:
                    '${DateFormat('d MMM yyyy').format(event!.datetime!)}, ${eventActionController.formatTime(event!.startTime!)}–${eventActionController.formatTime(event!.endTime!)}',
              ),
              const SizedBox(height: 12),
              _buildInfoItem(
                context,
                icon: Icons.map_outlined,
                title: 'LOCATION',
                subtitle: event?.address ?? '-',
              ),
              const SizedBox(height: 16),
              _buildInfoItem(
                context,
                icon: Icons.confirmation_num_outlined,
                title: 'HTM',
                subtitle:
                    "${(event?.price == null || event?.price == 0) ? 'Free' : event?.price}",
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Going list
          Obx(() {
            if (controller.isLoading.value) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: _personGridList(
                  context: context,
                  title: 'Going',
                  itemCount: 3,
                  itemBuilder: (context, index) => _buildPersonList(context),
                ),
              );
            }
            return _personGridList(
              context: context,
              title: 'Going',
              seeAll: true,
              itemCount: controller.usersInvites.length,
              itemBuilder: (context, index) => _buildPersonList(
                context,
                controller.usersInvites[index],
              ),
            );
          }),
          const SizedBox(height: 15),
          // Waitlist
          Obx(() {
            if (controller.isLoadingWaitList.value) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: _personGridList(
                  context: context,
                  title: 'Waitlist',
                  itemCount: 3,
                  itemBuilder: (context, index) => _buildPersonList(context),
                ),
              );
            }
            return _personGridList(
              context: context,
              title: 'Waitlist',
              itemCount: controller.usersWaitings.length,
              itemBuilder: (context, index) => _buildPersonList(
                context,
                controller.usersWaitings[index],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _personGridList(
      {required BuildContext context,
      bool seeAll = false,
      required String title,
      required int itemCount,
      required Widget Function(BuildContext, int) itemBuilder}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title ($itemCount)',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (seeAll) ...[
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.eventSeeAllParticipant,
                      arguments: {'eventId': event?.id}),
                  child: Text(
                    'See all',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ]
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            padding: const EdgeInsets.only(bottom: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: itemCount,
            itemBuilder: itemBuilder,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonList(BuildContext context, [EventUserModel? user]) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFF4C4C4C),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: user?.user?.imageUrl ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const ShimmerLoadingCircle(size: 50),
              errorWidget: (context, url, error) => const CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage('assets/images/empty_profile.png'),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user?.user?.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
