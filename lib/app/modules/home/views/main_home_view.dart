import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/modules/home/controllers/main_home_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

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
  static const double _startButtonDiameter = 84.0;

  Widget _buildNavItem(
    BuildContext context, {
    required String svgPath,
    required int index,
    required Function() onTap,
  }) {
    final bool isSelected = controller.currentIndex.value == index;
    final Color inactiveColor = Theme.of(context).colorScheme.secondary;

    Widget iconWidget;

    if (isSelected) {
      iconWidget = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) {
          return kStartButtonGradient.createShader(bounds);
        },
        child: SvgPicture.asset(
          svgPath,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          height: 23.h,
        ),
      );
    } else {
      iconWidget = SvgPicture.asset(
        svgPath,
        colorFilter: ColorFilter.mode(
          inactiveColor,
          BlendMode.srcIn,
        ),
        height: 23.h,
      );
    }

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: iconWidget,
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      height: MainHomeView._startButtonDiameter.r,
      width: MainHomeView._startButtonDiameter.r,
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.activityStart);
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: kStartButtonGradient,
            border: Border.all(
              color: darkColorScheme.tertiary,
              width: 5,
              strokeAlign: BorderSide.strokeAlignCenter,
            ),
          ),
          child: Center(
            child: Material(
              type: MaterialType.transparency,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'START',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontSize: 20.sp,
                    color: darkColorScheme.onPrimary,
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
    final double bottomBarHeight = 53.h;
    // Menggunakan _startButtonDiameter yang sudah didefinisikan di atas
    // untuk konsistensi pada spacer dan kalkulasi posisi.

    return SafeArea(
      child: Stack(
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
                    _buildNavItem(context,
                        svgPath: 'assets/icons/ic_home.svg',
                        index: 0,
                        onTap: () => controller.changeTab(0)),
                    _buildNavItem(context,
                        svgPath: 'assets/icons/ic_social.svg',
                        index: 1,
                        onTap: () => controller.changeTab(1)),
                    // Spacer untuk tombol START di tengah, menggunakan _startButtonDiameter
                    
                    const SizedBox(
                      
                      width: _startButtonDiameter),
                    _buildNavItem(context,
                        svgPath: 'assets/icons/ic_shop.svg',
                        index: 2,
                        onTap: () => controller.changeTab(2)),
                    _buildNavItem(context,
                        svgPath: 'assets/icons/ic_profile.svg',
                        index: 3,
                        onTap: () => controller.changeTab(3)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            // Menggunakan _startButtonDiameter untuk kalkulasi posisi
            bottom: bottomBarHeight -
                (_startButtonDiameter /
                    1.7), // Sesuaikan nilai 1.7 ini untuk seberapa menonjolnya
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: _buildStartButton(context),
            ),
          ),
        ],
      ),
    );
  }
}
