// file: app/modules/home/widgets/stamina_recovery_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zest_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class StaminaRecoveryPopup extends StatelessWidget {
  StaminaRecoveryPopup({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFF2E2E2E), // Warna background popup
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: const Color(0xFFA2FF00), width: 1.5),
        ),
        // ✨ KUNCI PERBAIKAN: Bungkus Column dengan IntrinsicWidth ✨
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min, // Jaga agar Row tetap seukuran kontennya
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_energy.svg',
                    height: 16.h,
                  ),
                  SizedBox(width: 8.w),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFA2FF00),
                        Color(0xFF00FF7F),
                      ],
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Text(
                      'Stamina Recovery',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              // Divider sekarang akan direntangkan sesuai lebar Row di atasnya
              const Divider(
                color: Color(0xFF4A4A4A), // Warna yang lebih sesuai dengan desain
                thickness: 0.8,
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '+Stamina in: ',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12.sp,
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFA2FF00),
                        Color(0xFF00FF7F),
                      ],
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: Obx(
                      () {
                        return Text(
                          controller.staminaRecoveryCountdown.value,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
