import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_widget/sliding_widget.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/modules/activity/start_activity/controllers/start_activity_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class StartActivityView extends GetView<StartActivityController> {
  const StartActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Running',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
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
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Obx(() => Text(
      //             controller.isTracking.value 
      //                 ? "Sedang Melacak..." 
      //                 : "Tekan Mulai untuk Melacak",
      //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: controller.isTracking.value ? Colors.green : Colors.red ),
      //           )),
      //       const SizedBox(height: 20),
      //       Obx(() => Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           Column(
      //             children: [
      //               const Text("Langkah Sesi Ini:", style: TextStyle(fontSize: 16)),
      //               Text(
      //                 "${controller.stepsInSession.value}",
      //                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //               ),
      //             ],
      //           ),
      //           Column(
      //             children: [
      //               const Text("Jarak Tempuh:", style: TextStyle(fontSize: 16)),
      //               Text(
      //                 controller.formatDistance(controller.currentDistanceInMeters.value),
      //                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //               ),
      //             ],
      //           ),
      //         ],
      //       )),
      //       const SizedBox(height: 20),
      //       const Text(
      //         "Data Titik Lokasi:",
      //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //       ),
      //       const SizedBox(height: 8),
      //       Expanded(
      //         child: Obx(
      //           () {
      //             if (controller.currentPath.isEmpty) {
      //               return const Center(child: Text("Belum ada data lokasi."));
      //             }
      //             return ListView.builder(
      //               itemCount: controller.currentPath.length,
      //               itemBuilder: (context, index) {
      //                 final point = controller.currentPath[index];
      //                 // Tampilkan beberapa titik terakhir saja jika daftarnya panjang untuk UI
      //                 // int displayIndex = controller.currentPath.length - 1 - index;
      //                 // final point = controller.currentPath[displayIndex];
      //                 return Card(
      //                   margin: const EdgeInsets.symmetric(vertical: 4),
      //                   child: Padding(
      //                     padding: const EdgeInsets.all(8.0),
      //                     child: Text(
      //                       // Menggunakan toString() dari LocationPoint yang sudah di-override
      //                       '${index + 1}. ${point.toString()}',
      //                       style: const TextStyle(fontSize: 12),
      //                     ),
      //                   ),
      //                 );
      //               },
      //             );
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // floatingActionButton: Obx(
      //   () => FloatingActionButton.extended(
      //     onPressed: () {
      //       if (controller.isTracking.value) {
      //         controller.stopActivity();
      //       } else {
      //         controller.startActivity();
      //       }
      //     },
      //     label: Text(controller.isTracking.value ? "Selesai" : "Mulai"),
      //     icon: Icon(controller.isTracking.value ? Icons.stop : Icons.play_arrow),
      //     backgroundColor: controller.isTracking.value ? Colors.red : Colors.green,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                      Text(
                        '2.5',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
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
                        '10/10',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Obx(
              () {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Visibility(
                    visible: controller.currentPosition.value != null,
                    replacement: const Center(child: CircularProgressIndicator()),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: controller.currentPosition.value ?? const LatLng(-6.2615, 106.8106),
                        zoom: 16,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('currentLocation'),
                          position: controller.currentPosition.value ?? const LatLng(-6.2615, 106.8106),
                          icon: BitmapDescriptor.defaultMarker,
                        ),
                      },
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
                    ),
                  )
                );
              }
            ),
            const SizedBox(height: 48),
            Obx(
              () {
                return Visibility(
                  visible: controller.currentPosition.value != null,
                  child: Center(
                    child: SlidingWidget(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 70,
                      backgroundColor: const Color(0xFF2E2E2E),
                      backgroundColorEnd: const Color(0xFF2E2E2E),
                      foregroundColor: darkColorScheme.primary,
                      iconColor: darkColorScheme.onPrimary,
                      label: 'Start Your Zest+!',
                      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: darkColorScheme.onBackground,
                      ),
                      shadow: const BoxShadow(
                        color: Colors.transparent,
                        blurRadius: 0,
                        offset: Offset(0, 0),
                      ),
                      action: () {
                        print('Start Your Zest+!');
                        Get.offAndToNamed(AppRoutes.activityRecord);
                      },
                      onTapDown: () {
                        print('[onTapDown] Start Your Zest+!');
                      },
                      onTapUp: () {
                        print('[onTapUp] Start Your Zest+!');
                      },
                      stickToEnd: true,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: darkColorScheme.onPrimary,
                      ),
                    ),
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}