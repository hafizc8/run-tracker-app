import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            // Map placeholder
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey.shade300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.map, size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Map Placeholder',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Use current location button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.my_location_outlined),
                label: Text('Use Current Location'),
              ),
            ),

            const SizedBox(height: 8),

            // Address
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
