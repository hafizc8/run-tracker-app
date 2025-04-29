import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/social/controllers/social_controller.dart';
import 'package:zest_mobile/app/modules/social/widgets/event_detail_card.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class SocialForYouEventDetailView extends GetView<SocialController> {
  const SocialForYouEventDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: const SingleChildScrollView(
        child: EventDetailCard(),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.primary,
          size: 35,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Event Details',
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: Colors.transparent,
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            // Handle the selection
            if (value == 'edit') {
              // Handle Edit Event action
            } else if (value == 'delete') {
              // Handle Delete Event action
            }
          },
          icon: Icon(
            Icons.more_horiz,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'edit',
                child: Text(
                  'Edit Event',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  'Delete Event',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Expanded(
          //   child: ElevatedButtonTheme(
          //     data: ElevatedButtonThemeData(
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: Theme.of(context).colorScheme.primary,
          //         foregroundColor: Theme.of(context).colorScheme.onPrimary,
          //         minimumSize: const Size.fromHeight(40),
          //       ),
          //     ),
          //     child: ElevatedButton(
          //       onPressed: () {
          //         Get.back();
          //       },
          //       child: Text(
          //         'Join Event',
          //         style: Theme.of(context).textTheme.labelSmall,
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(
            child: OutlinedButtonTheme(
              data: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  minimumSize: const Size.fromHeight(40),
                  side: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
              ),
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Leave Event',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButtonTheme(
              data: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  minimumSize: const Size.fromHeight(40),
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.socialYourPageEventDetailInviteFriend);
                },
                child: Text(
                  'Invite a Friend',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}