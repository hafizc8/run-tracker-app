import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/register_create_profile_controller.dart';

class RegisterCreateProfileChooseLocationView
    extends GetView<RegisterCreateProfileController> {
  const RegisterCreateProfileChooseLocationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text(
          'Location',
        ),
        elevation: 1,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TypeAheadField<Map<String, dynamic>>(
                builder: (context, controller, focusNode) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                    ),
                  );
                },
                suggestionsCallback: (pattern) {
                  controller.searchPlace(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion['description']),
                  );
                },
                onSelected: (suggestion) {
                  // controller.selectPlace(suggestion['place_id']);
                },
              ),
            ),
            Obx(
              () => SizedBox(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: controller.currentPosition.value,
                    zoom: 16,
                  ),
                  onMapCreated: controller.onMapCreated,
                  onCameraMove: controller.onCameraMove,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  minMaxZoomPreference: MinMaxZoomPreference(5, 20),
                  // Indonesia Bounds (kurang lebih)
                  cameraTargetBounds: CameraTargetBounds(
                    LatLngBounds(
                      southwest: LatLng(-11.0, 95.0),
                      northeast: LatLng(6.0, 141.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.my_location_outlined),
                label: Text('Use Current Location'),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Jl. Jenderal Sudirman Blok Lot 11 No.Kav 58, RT.5/RW.3, Senayan, Kec. Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12190',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       // Search bar
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //         child: TextFormField(
      //           decoration: const InputDecoration(
      //             hintText: 'Search',
      //             prefixIcon: Icon(Icons.search),
      //           ),
      //         ),
      //       ),

      //       // Map placeholder
      //       Obx(
      //         () => SizedBox(
      //           height: 300,
      //           child: GoogleMap(
      //             initialCameraPosition: CameraPosition(
      //               target: controller.currentPosition.value,
      //               zoom: 16,
      //             ),
      //             onMapCreated: controller.onMapCreated,
      //             onCameraMove: controller.onCameraMove,
      //             myLocationEnabled: true,
      //             myLocationButtonEnabled: true,
      //             zoomControlsEnabled: false,
      //             minMaxZoomPreference: MinMaxZoomPreference(5, 20),
      //             // Indonesia Bounds (kurang lebih)
      //             cameraTargetBounds: CameraTargetBounds(
      //               LatLngBounds(
      //                 southwest: LatLng(-11.0, 95.0),
      //                 northeast: LatLng(6.0, 141.0),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),

      //       const SizedBox(height: 12),

      //       // Use current location button
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 16),
      //         child: OutlinedButton.icon(
      //           onPressed: () {},
      //           icon: Icon(Icons.my_location_outlined),
      //           label: Text('Use Current Location'),
      //         ),
      //       ),

      //       const SizedBox(height: 8),

      //       // Address
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 16),
      //         child: Text(
      //           'Jl. Jenderal Sudirman Blok Lot 11 No.Kav 58, RT.5/RW.3, Senayan, Kec. Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12190',
      //           style: TextStyle(fontSize: 14),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('Update'),
        ),
      ),
    );
  }
}
