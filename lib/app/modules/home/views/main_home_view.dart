import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/modules/home/controllers/main_home_controller.dart';

// Definisikan gradient untuk tombol START di sini atau impor dari file tema Anda
const LinearGradient kStartButtonGradient = LinearGradient(
  colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

class MainHomeView extends GetView<MainHomeController> {
  const MainHomeView({super.key});

  // Ukuran Tombol START (diameter)
  // Didefinisikan di sini agar konsisten digunakan di _buildStartButton dan di Row spacer
  static const double _startButtonDiameter = 80.0;


  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required Function() onTap,
  }) {
    final bool isSelected = controller.currentIndex.value == index;
    final Color activeColor = Theme.of(context).colorScheme.primary;
    final Color inactiveColor = Theme.of(context).colorScheme.secondary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    // fabSize sekarang menggunakan konstanta _startButtonDiameter
    return SizedBox(
      height: MainHomeView._startButtonDiameter,
      width: MainHomeView._startButtonDiameter,
      child: GestureDetector(
        onTap: () {
          print("Tombol START ditekan!");
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: kStartButtonGradient,
            border: Border.all(
              color: Theme.of(context).colorScheme.tertiary,
              width: 5,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(1),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'START',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double bottomBarHeight = 70.0;
    // Menggunakan _startButtonDiameter yang sudah didefinisikan di atas
    // untuk konsistensi pada spacer dan kalkulasi posisi.

    return Stack(
      children: [
        Obx(
          () => Scaffold(
            body: controller.pages[controller.currentIndex.value],
            bottomNavigationBar: Container(
              height: bottomBarHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _buildNavItem(context, icon: Icons.home_outlined, label: 'Home', index: 0, onTap: () => controller.changeTab(0)),
                  _buildNavItem(context, icon: Icons.people_outline, label: 'Social', index: 1, onTap: () => controller.changeTab(1)),
                  // Spacer untuk tombol START di tengah, menggunakan _startButtonDiameter
                  const SizedBox(width: _startButtonDiameter),
                  _buildNavItem(context, icon: Icons.shopping_bag_outlined, label: 'Shop', index: 2, onTap: () => controller.changeTab(2)),
                  _buildNavItem(context, icon: Icons.person_outline, label: 'Profile', index: 3, onTap: () => controller.changeTab(3)),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          // Menggunakan _startButtonDiameter untuk kalkulasi posisi
          bottom: bottomBarHeight - (_startButtonDiameter / 1.7), // Sesuaikan nilai 1.7 ini untuk seberapa menonjolnya
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: _buildStartButton(context),
          ),
        ),
      ],
    );
  }
}