import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/model/location_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/choose_location_event/controllers/choose_location_event_controller.dart';

class ChooseLocationEventView extends GetView<ChooseLocationEventController> {
  const ChooseLocationEventView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.chevron_left,
            size: 48,
            color: Color(0xFFA5A5A5),
          ),
        ),
        title: Text(
          'Location',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Color(0xFFA5A5A5),
              ),
        ),
        elevation: 1,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TypeAheadField<LocationModel>(
                builder: (context, controller, focusNode) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search',
                    ),
                  );
                },
                suggestionsCallback: (pattern) async {
                  final results = await controller.searchPlace(pattern);

                  // Tambahkan "Gunakan lokasi saat ini" di atas
                  final currentLocation = LocationModel(
                    placeId: '__current_location__',
                    desc: 'Use Current Location',
                  );

                  return [currentLocation, ...results ?? []];
                },
                itemBuilder: (context, suggestion) {
                  final isCurrentLocation =
                      suggestion.placeId == '__current_location__';

                  return ListTile(
                    leading: Icon(
                      isCurrentLocation ? Icons.my_location : Icons.location_on,
                      color: isCurrentLocation
                          ? Theme.of(context).primaryColor
                          : null,
                    ),
                    title: Text(suggestion.desc),
                  );
                },
                onSelected: (suggestion) {
                  FocusScope.of(context).unfocus();

                  if (suggestion.placeId == '__current_location__') {
                    // Handle ambil lokasi saat ini
                    controller.setCurrentLocation();
                  } else {
                    controller.selectPlace(suggestion.placeId);
                  }
                },
                emptyBuilder: (context) {
                  // Tetap tampilkan "Gunakan lokasi saat ini" meski tidak ada hasil
                  final currentLocation = LocationModel(
                    placeId: '__current_location__',
                    desc: 'Use Current Location',
                  );

                  return ListTile(
                    leading: const Icon(Icons.my_location, color: Colors.blue),
                    title: Text(currentLocation.desc),
                    onTap: () {
                      controller.setCurrentLocation();
                      Get.back(); // tutup box
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  Visibility(
                    visible: controller.currentPosition.value != null,
                    replacement:
                        const Center(child: CircularProgressIndicator()),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: controller.currentPosition.value!,
                        zoom: 16,
                      ),
                      onMapCreated: controller.onMapCreated,
                      onCameraMove: controller.onCameraMove,
                      onCameraIdle: controller.onCameraIdle,
                      onCameraMoveStarted: controller.onCameraMoveStarted,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
                      // Indonesia Bounds (kurang lebih)
                      cameraTargetBounds: CameraTargetBounds(
                        LatLngBounds(
                          southwest: const LatLng(-11.0, 94.0),
                          northeast: const LatLng(6.0, 141.0),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.location_pin,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Place Name',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.text,
                    controller: controller.placeNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Place Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'The place name is required';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => Visibility(
                  visible: !controller.isLoading.value,
                  replacement: const Text('Load address...'),
                  child: Visibility(
                    visible: controller.address.value.isNotEmpty,
                    replacement:
                        const Text('Drag the map to move your location'),
                    child: Text(
                      controller.address.value,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        height: 55,
        child: Obx(
          () => GradientElevatedButton(
            onPressed: !controller.canUpdate
                ? null
                : () => Get.back(result: {
                      'address': controller.address.value,
                      'placeName': controller.placeNameController.text,
                      'location': controller.currentPosition.value,
                    }),
            child: const Text('Update'),
          ),
        ),
      ),
    );
  }
}
