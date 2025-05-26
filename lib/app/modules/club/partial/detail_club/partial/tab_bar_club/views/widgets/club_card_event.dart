import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/models/model/event_model.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/widgets/activity_attribute.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/widgets/badge_activity_type.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/widgets/participants_avatars.dart';

class ClubCardEvent extends StatelessWidget {
  const ClubCardEvent({super.key, required this.event});

  final EventModel? event;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Placeholder(
              fallbackHeight: 128,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const BadgeActivityType(),
            const SizedBox(height: 16),
            Text(
              event?.title ?? '-',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'PARTICIPANTS',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ParticipantsAvatars(imageUrls: const [
              'https://dev.zestplus.app/storage/users/pYrTSrYTTnUEoVIsAG8gg6rrIxdeWcEzyG1FLqNI.png',
              'https://dev.zestplus.app/storage/users/pYrTSrYTTnUEoVIsAG8gg6rrIxdeWcEzyG1FLqNI.png',
              'https://dev.zestplus.app/storage/users/5zjm9MFFIxp7PClkSyr20PXoGAwNbCY1ZXx6fni5.jpg',
              'https://dev.zestplus.app/storage/users/pYrTSrYTTnUEoVIsAG8gg6rrIxdeWcEzyG1FLqNI.png',
              'https://dev.zestplus.app/storage/users/pYrTSrYTTnUEoVIsAG8gg6rrIxdeWcEzyG1FLqNI.png',
              'https://dev.zestplus.app/storage/users/pYrTSrYTTnUEoVIsAG8gg6rrIxdeWcEzyG1FLqNI.png',
              'https://dev.zestplus.app/storage/users/pYrTSrYTTnUEoVIsAG8gg6rrIxdeWcEzyG1FLqNI.png',
              'https://dev.zestplus.app/storage/users/5zjm9MFFIxp7PClkSyr20PXoGAwNbCY1ZXx6fni5.jpg',
              'https://dev.zestplus.app/storage/users/pYrTSrYTTnUEoVIsAG8gg6rrIxdeWcEzyG1FLqNI.png',
              'https://dev.zestplus.app/storage/users/pYrTSrYTTnUEoVIsAG8gg6rrIxdeWcEzyG1FLqNI.png',
              'https://dev.zestplus.app/storage/users/pYrTSrYTTnUEoVIsAG8gg6rrIxdeWcEzyG1FLqNI.png',
              'https://dev.zestplus.app/storage/users/pYrTSrYTTnUEoVIsAG8gg6rrIxdeWcEzyG1FLqNI.png',
            ]),
            const SizedBox(height: 16),
            ActivityAttribute(
              attributes: const [
                {
                  'title': 'DATE & TIME',
                  'icon': 'uil_calendar',
                  'data': '14 February 2025, 17:00 - 19:00',
                },
                {
                  'title': 'LOCATION',
                  'icon': 'hugeicons_maps',
                  'data': 'Anywhere',
                },
                {
                  'title': 'TARGET',
                  'icon': 'mingcute_target-line',
                  'data': '50000',
                },
                {
                  'title': 'HTM',
                  'icon': 'solar_money-bag-outline',
                  'data': 'Free',
                },
              ]
            ),
          ],
        ),
      ),
    );
  }
}
