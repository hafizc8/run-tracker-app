import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/social/widgets/social_action_button.dart';
import 'package:zest_mobile/app/modules/social/widgets/statistic_column.dart';
import '../controllers/social_controller.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';

class SocialView extends GetView<SocialController> {
  const SocialView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Social',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.3),
          surfaceTintColor: Colors.transparent,
          actions: [
            // Text + Icon Button "Create"
            TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.add, 
                size: 20,
                color: lightColorScheme.primary,
              ),
              label: Text(
                'CREATE',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: lightColorScheme.primary,
                ),
              ),
            ),

            // Vertical Divider
            Container(
              height: 24,
              width: 1,
              color: Colors.black.withOpacity(0.2),
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),

            // Circle IconButton
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 10,),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search,
                  size: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),

          ],
        ),

        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(height: 16),

            // Custom TabBar dengan rounded dan background
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: [
                    // TabBar
                    TabBar(
                      indicator: BoxDecoration(
                        color: lightColorScheme.primary, // Gunakan primary dari lightColorScheme
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 1,
                      labelColor: Colors.white,
                      unselectedLabelColor: lightColorScheme.primary,
                      labelStyle: Theme.of(context).textTheme.bodyLarge,
                      unselectedLabelStyle: Theme.of(context).textTheme.bodyLarge,
                      tabs: const [
                        Tab(text: 'Your Page'),
                        Tab(text: 'For You'),
                      ],
                    ),
                    // Garis bawah TabBar yang merentang penuh
                    Container(
                      height: 1,
                      color: lightColorScheme.primary, // Warna garis bawah
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // TabBarView
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                child: TabBarView(
                  children: [
                    // Halaman "Your Page"
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Chip Badge yang bisa diklik
                          Wrap(
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            runSpacing: 8.0,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 8.0,
                            children: [
                              Chip(
                                label: const Text('Updates'),
                                backgroundColor: const Color(0xFFdaebfe),
                                labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: lightColorScheme.primary,
                                    width: 1,
                                  ),
                                ),
                              ),
                              Chip(
                                label: const Text('Friends'),
                                backgroundColor: const Color(0xFFdaebfe),
                                labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                              ),
                              Chip(
                                label: const Text('Friend Request'),
                                backgroundColor: const Color(0xFFdaebfe),
                                labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                    color: Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      
                          const SizedBox(height: 10),
                      
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: lightColorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  color: lightColorScheme.onPrimary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Doing some sports today? Share it!',
                                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                      
                          // Card Content
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: lightColorScheme.background,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // User Profile in Card
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.grey.shade300,
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'John Doe',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          'Today, San Francisco, 05:00 AM',
                                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: lightColorScheme.onTertiary),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.more_horiz,
                                      ),
                                      color: lightColorScheme.primary,
                                    ),
                                  ],
                                ),
                      
                                const SizedBox(height: 8),
                      
                                // Text Content
                                Text(
                                  'Morning Walk',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontSize: 18,
                                    color: lightColorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'Freezing morning run',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: lightColorScheme.onSurface,
                                  ),
                                ),
                      
                                const SizedBox(height: 8),
                      
                                // Map placeholder
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      color: Colors.grey.shade300,
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.map, size: 64, color: Colors.grey),
                                            SizedBox(height: 8),
                                            Text('Map Placeholder', style: TextStyle(color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),
                      
                                // Statistics Column
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: lightColorScheme.primary,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      StatisticsColumn(title: 'DISTANCE', value: '2.57 km'),
                                      StatisticsColumn(title: 'STEPS', value: '4,052'),
                                      StatisticsColumn(title: 'AVG. PACE', value: '8:10'),
                                      StatisticsColumn(title: 'MOVING TIME', value: '37:17'),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 15),

                                // Like, Comment, Share
                                Row(
                                  children: [
                                    SocialActionButton(
                                      icon: Icons.local_fire_department_outlined,
                                      label: 'Like',
                                      onTap: () {},
                                    ),
                                    const SizedBox(width: 8),
                                    SocialActionButton(
                                      icon: Icons.chat_bubble_outline,
                                      label: 'Comment',
                                      onTap: () {},
                                    ),
                                    const SizedBox(width: 8),
                                    SocialActionButton(
                                      icon: Icons.share_outlined,
                                      label: 'Share',
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Center(child: Text('For You')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
