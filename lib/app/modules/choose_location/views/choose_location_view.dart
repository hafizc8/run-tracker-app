import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/models/model/location_model.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/modules/choose_location/controllers/choose_location_controller.dart';

class ChooseLocationView extends GetView<ChooseLocationController> {
  const ChooseLocationView({super.key});
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
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
            GradientOutlinedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/ic_loc.svg'),
                  const SizedBox(width: 8),
                  const Text('Use current location'),
                ],
              ),
              onPressed: () {
                controller.setCurrentLocation();
              },
            ),
            const SizedBox(height: 12),
            Obx(
              () => Visibility(
                visible: !controller.isLoading.value,
                replacement: const Text('Load address...'),
                child: Visibility(
                  visible: controller.address.value.isNotEmpty,
                  replacement: const Text('Drag the map to move your location'),
                  child: Text(
                    controller.address.value,
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
            contentPadding: EdgeInsets.zero,
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
