import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/custom_dialog_confirmation.dart';
import 'package:zest_mobile/app/modules/activity/record_activity/controllers/record_activity_controller.dart';

class RecordActivityView extends GetView<RecordActivityController> {
  const RecordActivityView({super.key});

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
          onTap: () {
            // confirm dialog
            Get.dialog(
              CustomDialogConfirmation(
                title: 'Delete Activity',
                subtitle: 'Are you sure you want to delete this activity?',
                labelConfirm: 'Yes',
                onConfirm: () {
                  controller.deleteActivity();
                  Get.back(closeOverlays: true);
                },
              )
            );
          },
          child: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(height: Get.height),
        child: Stack(
          children: [
            // Layer Background Image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: Get.height,
              child: SvgPicture.asset(
                "assets/images/z-background-full.svg",
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 38),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                            Obx(
                              () {
                                return Text(
                                  '${controller.userCoin.value.toPrecision(2)}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                );
                              }
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Obx(() => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                              '${controller.staminaRemainingCount.value}/${controller.totalStaminaToUse.value}',
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
                      )),
                    ],
                  ),
              
                  const SizedBox(height: 48),
              
                  Obx(
                    () {
                      return IndexedStack(
                        index: controller.isMapViewMode.value ? 0 : 1,
                        children: [
                          // Layer Map
                          Visibility(
                            visible: controller.currentPath.isNotEmpty,
                            replacement: Container(
                              height: 310,
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CircularProgressIndicator(),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Please move your device to start recording',
                                    style: Theme.of(context).textTheme.titleSmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            child: Container(
                              height: 310,
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    controller.currentPath.length > 1 ? controller.currentPath.last.latitude : 0, 
                                    controller.currentPath.length > 1 ? controller.currentPath.last.longitude : 0,
                                  ),
                                  zoom: 16,
                                ),
                                myLocationEnabled: false,
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,
                                minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
                                polylines: controller.activityPolylines, 
                                onMapCreated: controller.onMapCreated,
                                markers: {
                                  // Tampilkan marker hanya jika ada rute yang sudah digambar
                                  if (controller.currentPath.isNotEmpty) ...[
                                    // Marker untuk Titik Start
                                    Marker(
                                      markerId: const MarkerId('start_point'),
                                      position: LatLng(
                                        controller.currentPath.first.latitude,
                                        controller.currentPath.first.longitude,
                                      ),
                                      icon: controller.startIcon,
                                      anchor: const Offset(0, 1),
                                    ),
                                    
                                    // Marker untuk Titik End3
                                    if (controller.currentPath.length > 1)
                                      Marker(
                                        markerId: const MarkerId('end_point'),
                                        position: LatLng(
                                          controller.currentPath.last.latitude,
                                          controller.currentPath.last.longitude,
                                        ),
                                        icon: controller.endIcon, // Gunakan ikon dari controller
                                        anchor: const Offset(0.5, 0.5),
                                      ),
                                  ]
                                },
                              ),
                            ),
                          ),
              
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/ic_time.svg',
                                      ),
                                      const SizedBox(height: 8),
                                      Obx(
                                        () {
                                          return Text(
                                            controller.formattedElapsedTime,
                                            style: Theme.of(context).textTheme.titleSmall
                                          );
                                        }
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 48),
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/ic_people_run.svg',
                                      ),
                                      const SizedBox(height: 8),
                                      Obx(
                                        () {
                                          return Text(
                                            controller.distance,
                                            style: Theme.of(context).textTheme.titleSmall,
                                          );
                                        }
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          
                              const SizedBox(height: 48),
                          
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/ic_shoes_2.svg',
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Pace',
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: const Color(0xFFA5A5A5),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),

                              Obx(
                                () {
                                  return Text(
                                    controller.formattedPace.value,
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: const Color(0xFFDCDCDC),
                                      fontSize: 100,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                }
                              ),

                              Obx(() {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  switchInCurve: Curves.easeOutCubic,
                                  switchOutCurve: Curves.easeInCubic,
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    final bool isLeaving = child.key != ValueKey(controller.showCoinAnimation.value);

                                    // Tentukan pergeseran (offset) berdasarkan status masuk atau keluar
                                    final Tween<Offset> tween = isLeaving
                                        // Jika keluar, geser dari tengah (0,0) ke atas (0, -0.5)
                                        ? Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.1))
                                        // Jika masuk, geser dari bawah (0, 0.5) ke tengah (0,0)
                                        : Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero);

                                    // Gabungkan animasi slide dan fade
                                    return SlideTransition(
                                      position: tween.animate(animation),
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: controller.showCoinAnimation.value
                                      ? Row(
                                          // Gunakan key yang merefleksikan state saat ini (true)
                                          key: const ValueKey(true),
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/ic_coin.svg',
                                              width: 27,
                                            ),
                                            const SizedBox(width: 8),
                                            // Tambahkan AnimatedSwitcher di dalam untuk menganimasikan perubahan teks
                                            AnimatedSwitcher(
                                              duration: const Duration(milliseconds: 300),
                                              transitionBuilder: (child, animation) =>
                                                  FadeTransition(opacity: animation, child: child),
                                              child: Text(
                                                // Gunakan key dari nilai koin agar teks beranimasi saat nilainya berubah
                                                '+${controller.coinsEarned.value}',
                                                key: ValueKey<int>(controller.coinsEarned.value.toInt()),
                                                style: GoogleFonts.poppins(
                                                  color: darkColorScheme.primary,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      // Gunakan SizedBox dengan key yang berbeda untuk state kosong
                                      : const SizedBox.shrink(key: ValueKey(false)),
                                );
                              }),

                            ],
                          ),
                        ],
                      );
                    }
                  ),
              
                  const SizedBox(height: 48),
              
                  Obx(
                    () {
                      if (controller.isStartingActivity.value || controller.isLoadingStaminaDialog.value) {
                        return Container(
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                SizedBox(height: 20),
                                Text(
                                  'Preparing your activity...',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (controller.isLoadingSaveRecordActivity.value && controller.elapsedTimeInSeconds.value == 0) {
                        return const Center(child: CircularProgressIndicator());
                      }
              
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF373737),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.isMapViewMode.value = !controller.isMapViewMode.value;
                              },
                              child: Obx(() => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF5A5A5A),
                                    width: 2,
                                  )
                                ),
                                padding: const EdgeInsets.all(18),
                                child: FaIcon(
                                  controller.isMapViewMode.value ? FontAwesomeIcons.solidFlag : FontAwesomeIcons.locationArrow,
                                  size: 28,
                                  color: const Color(0xFF5A5A5A),
                                ),
                              )),
                            ),
                                
                            InkWell(
                              onTap: () {
                                controller.togglePauseResume();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: darkColorScheme.primary,
                                ),
                                padding: const EdgeInsets.all(32),
                                child: Obx(
                                  () {
                                    return FaIcon(
                                      controller.isPaused.value ? FontAwesomeIcons.play : FontAwesomeIcons.pause,
                                      size: 48,
                                      color: darkColorScheme.onPrimary,
                                    );
                                  }
                                ),
                              ),
                            ),
                                
                            InkWell(
                              onTap: () {
                                Get.dialog(
                                  CustomDialogConfirmation(
                                    title: 'Stop Activity',
                                    subtitle: 'Are you sure you want to stop the activity?',
                                    labelConfirm: 'Yes',
                                    onConfirm: () {
                                      Get.back();
                                      controller.checkBeforeStopActivity();
                                    },
                                  )
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF5A5A5A),
                                    width: 2,
                                  )
                                ),
                                padding: const EdgeInsets.all(18),
                                child: const FaIcon(
                                  FontAwesomeIcons.stop,
                                  size: 28,
                                  color: Color(0xFF5A5A5A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(-MediaQuery.of(context).size.width, 0), // Pindahkan ke luar layar
              child: RepaintBoundary(
                key: controller.startMarkerKey,
                child: const FaIcon(
                  FontAwesomeIcons.solidFlag,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-MediaQuery.of(context).size.width, 0),
              child: RepaintBoundary(
                key: controller.endMarkerKey,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.2), // Splash area
                  ),
                  child: Center(
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}