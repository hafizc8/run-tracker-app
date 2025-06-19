import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
// Pastikan path import ini benar sesuai struktur proyek Anda
import 'package:zest_mobile/app/core/shared/widgets/step_tracker_widget.dart';
import 'package:zest_mobile/app/modules/home/widgets/custom_exp_progress_bar.dart';
import 'package:zest_mobile/app/modules/home/widgets/walker_profile.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Widget Profile
                Container(
                  margin: const EdgeInsets.only(top: 36, left: 18, right: 18),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Afif Naufal',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF494949),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const FaIcon(
                          FontAwesomeIcons.solidBell,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF494949),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const FaIcon(
                          FontAwesomeIcons.solidEnvelope,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
          
                // Level
                Container(
                  margin: const EdgeInsets.only(left: 18, top: 10),
                  child: Row(
                    children: [
                      Text(
                        'Level 4',
                        style: Theme.of(context).textTheme.headlineSmall
                      ),
                      const SizedBox(width: 8),
                      // Widget Progress bar exp
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: const CustomExpProgressBar(
                          currentExp: 50,
                          maxExp: 100,
                          height: 15,
                        ),
                      ),
                    ],
                  ),
                ),
          
                // coin & energy
                Container(
                  margin: const EdgeInsets.only(left: 18, top: 14, bottom: 10),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_coin.svg',
                            width: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '2.5',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1.0
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/ic_energy.svg',
                            height: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '2/10',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1.0
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          
                // Widget Step Tracker
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 42),
                  child: Obx(() {
                    // Jika tidak ada error, tampilkan widget tracker.
                    return StepsTrackerWidget(
                      progressValue: controller.progressValue,
                      currentSteps: controller.currentSteps,
                      maxSteps: controller.maxSteps,
                    );
                  }),
                ),
                // Error message when step sensor not found
                Obx(
                  () {
                    return Visibility(
                      visible: (controller.error.isNotEmpty),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          controller.error,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.red.shade400,
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                ),
                Text(
                  'Just 20,000 steps left to crush your goal!',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_time.svg',
                          width: 15,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '60 Mins',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_calories.svg',
                          width: 15,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '100 Cal',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset(
                      'assets/icons/ic_share_3.svg',
                      width: 21,
                    ),
                  ],
                ),
          
                const SizedBox(height: 24),
          
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Agar judul "Top Walkers" rata kiri
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Top Walkers',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: darkColorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WalkerProfile(
                            rank: '1st',
                            name: 'James',
                            imageUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
                          ),
                          WalkerProfile(
                            rank: '2nd',
                            name: 'Danny',
                            imageUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
                          ),
                          WalkerProfile(
                            rank: '3rd',
                            name: 'Rico',
                            imageUrl: 'https://randomuser.me/api/portraits/men/3.jpg',
                          ),
                          // Profil Anda dengan background khusus
                          WalkerProfile(
                            rank: '55th',
                            name: 'Your',
                            imageUrl: 'https://randomuser.me/api/portraits/men/4.jpg',
                            backgroundColor: Color(0xFF393939),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 12),
          
                Container(
                  decoration: BoxDecoration(
                    color: darkColorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        'Challenge Your Friends!',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const Spacer(),
                      const FaIcon(
                        FontAwesomeIcons.circlePlus,
                        color: Color(0xFF5A5A5A),
                        size: 38,
                      ),
                    ],
                  ),
                ),
          
                const SizedBox(height: 36),
              ],
            ),
          ),

          Obx(() => Positioned(
            left: controller.iconPosition.value.dx,
            top: controller.iconPosition.value.dy,
            child: GestureDetector(
              // Panggil method dari controller
              onPanUpdate: (details) => controller.updateIconPosition(details, context),
              onPanEnd: (details) => controller.snapIconToEdge(context),

              // Widget ikon Anda
              child: SizedBox(
                width: controller.iconSize + 6,
                height: controller.iconSize + 17,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_streak.svg',
                      width: controller.iconSize,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          '1',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: const Color(0xFF292929),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
