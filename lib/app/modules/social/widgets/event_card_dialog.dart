import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/extension/date_extension.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';

class EventCardDialog extends StatelessWidget {
  EventCardDialog(
      {super.key,
      required this.onTap,
      this.eventModel,
      this.backgroundColor = Colors.white});

  final EventModel? eventModel;
  final void Function()? onTap;
  final Color backgroundColor;

  final eventController = Get.find<EventController>();
  final eventActionController = Get.find<EventActionController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey.shade300,
                  child: CachedNetworkImage(
                    imageUrl: eventModel?.imageUrl ?? '',
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade700,
                      child: const SizedBox.shrink(),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image,
                              size: 64, color: Colors.grey.shade800),
                          const SizedBox(height: 8),
                          const Text('Image Placeholder',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
            // title text
            Text(
              eventModel?.title ?? '-',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        icon: SvgPicture.asset(
                          'assets/icons/calendar.svg',
                          height: 22,
                          width: 27,
                        ),
                        title: 'Date & Time',
                        subtitle: (eventModel?.datetime ?? DateTime.now())
                            .toddMMMyyyy(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        icon: SvgPicture.asset(
                          'assets/icons/pin_location.svg',
                          height: 22,
                          width: 27,
                        ),
                        title: 'Location',
                        subtitle: eventModel?.address ?? '-',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        icon: SvgPicture.asset(
                          'assets/icons/dollar.svg',
                          height: 22,
                          width: 27,
                        ),
                        title: 'Fee',
                        subtitle:
                            "${(eventModel?.price == null || eventModel?.price == 0) ? 'Free' : eventModel?.price}",
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),

            GradientElevatedButton(
              onPressed: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.share, size: 20),
                  SizedBox(width: 8),
                  Text('Share'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required SvgPicture icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 12,
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
}
