import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/slide_to_act.dart';
import 'package:zest_mobile/app/modules/activity/start_activity/controllers/start_activity_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class StartActivityView extends GetView<StartActivityController> {
  const StartActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                color: darkColorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              'Running',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            )
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () {
                  if (controller.isLoadingGetUserData.value) {
                    return const SizedBox();
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF373737),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_coin.svg',
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${controller.user?.currentUserCoin?.currentAmount}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF373737),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_energy.svg',
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${controller.user?.currentUserStamina?.currentAmount}/${controller.user?.currentUserXp?.levelDetail?.staminaIncreaseTotal}',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              controller.formattedStaminaTime,
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: const Color(0xFF7B7B7B),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              ),
              const SizedBox(height: 24),
              Obx(() {
                return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Visibility(
                      visible: controller.currentPosition.value != null,
                      replacement:
                          const Center(child: CircularProgressIndicator()),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: controller.currentPosition.value ??
                              const LatLng(-6.2615, 106.8106),
                          zoom: 16,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('currentLocation'),
                            position: controller.currentPosition.value ??
                                const LatLng(-6.2615, 106.8106),
                            icon: BitmapDescriptor.defaultMarker,
                          ),
                        },
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
                      ),
                    ));
              }),
              const SizedBox(height: 48),
              Obx(
                () {
                  return Visibility(
                    visible: controller.currentPosition.value != null,
                    child: Center(
                      child: SlideToAction(
                        onSubmit: () {
                          Get.toNamed(AppRoutes.activityRecord);
                        },
                        sliderIcon: FaIcon(
                          FontAwesomeIcons.anglesRight,
                          color: darkColorScheme.onPrimary,
                          size: 32,
                        ),
                        textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF6C6C6C),
                        )
                      ),
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}