import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/model/location_model.dart';
import 'package:zest_mobile/app/modules/auth/register/controllers/register_create_profile_loc_controller.dart';

class RegisterCreateProfileChooseLocationView
    extends GetView<RegisterCreateProfileLocController> {
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
                suggestionsCallback: (pattern) =>
                    controller.searchPlace(pattern),
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion.desc),
                  );
                },
                onSelected: (suggestion) {
                  FocusScope.of(context).unfocus();
                  controller.selectPlace(suggestion.placeId);
                },
              ),
            ),
            Obx(
              () => SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: controller.initialPosition,
                      onMapCreated: controller.onMapCreated,
                      onCameraMove: controller.onCameraMove,
                      onCameraIdle: controller.onCameraIdle,
                      onCameraMoveStarted: controller.onCameraMoveStarted,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: false,
                      minMaxZoomPreference: const MinMaxZoomPreference(5, 20),
                      // Indonesia Bounds (kurang lebih)
                      cameraTargetBounds: CameraTargetBounds(
                        LatLngBounds(
                          southwest: const LatLng(-11.0, 95.0),
                          northeast: const LatLng(6.0, 141.0),
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
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () => controller.setCurrentLocation(),
                icon: const Icon(Icons.my_location_outlined),
                label: const Text('Use Current Location'),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => ElevatedButton(
            onPressed: !controller.canUpdate
                ? null
                : () => Get.back(result: {
                      'address': controller.address.value,
                      'location': controller.currentPosition.value,
                    }),
            child: const Text('Update'),
          ),
        ),
      ),
    );
  }
}
