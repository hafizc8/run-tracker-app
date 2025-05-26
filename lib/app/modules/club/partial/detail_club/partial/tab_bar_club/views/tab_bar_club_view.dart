import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/controllers/tab_bar_club_controller.dart';
import 'package:zest_mobile/app/modules/club/partial/detail_club/partial/tab_bar_club/views/club_activity_tab_view.dart';

class TabBarClub extends GetView<TabBarClubController> {
  TabBarClub({super.key});

  final List<String> tabs = ['Club Activity', 'Leaderboards'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColor, // Warna border
                width: 1.0, // Ketebalan border
              ),
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: List.generate(tabs.length, (index) {
              return Obx(() {
                final isSelected = controller.selectedIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.changeTabIndex(index),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      tabs[index],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                );
              });
            }),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          switch (controller.selectedIndex.value) {
            case 0:
              return ClubActivityTabView();
            case 1:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text('leaderboard'),
                    SizedBox(height: 20),
                    SizedBox(height: 500),
                  ],
                ),
              );
            default:
              return const SizedBox();
          }
        }),
      ],
    );
  }
}
