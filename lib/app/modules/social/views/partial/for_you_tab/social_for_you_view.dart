import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/event_card.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SocialForYouView extends GetView<SocialController> {
  const SocialForYouView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Upcoming Events Around You',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    items: ['Running', 'Badminton']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      border: const UnderlineInputBorder(),
                      hintText: 'Activity',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                  child: DropdownButtonFormField<String>(
                    items: ['Today', 'This Week', 'This Month']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      border: const UnderlineInputBorder(),
                      hintText: 'Date',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    icon: const Icon(Icons.date_range_outlined),
                    iconSize: 24,
                    iconEnabledColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    items: ['Anywhere', 'Jakarta', 'Medan', 'Surabaya']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      border: const UnderlineInputBorder(),
                      hintText: 'Location',
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
      
          // Card Event
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              return EventCard(
                onTap: () => Get.toNamed(AppRoutes.socialYourPageEventDetail),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}