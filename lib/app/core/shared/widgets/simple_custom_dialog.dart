import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_elevated_button.dart';

class SimpleCustomDialog extends StatelessWidget {
  final String title;
  final String description;

  const SimpleCustomDialog({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: const LinearGradient(
            colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2E2E2E),
            borderRadius: BorderRadius.circular(11.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Konten Utama ---
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: const Color(0xFFA2FF00),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              
              SizedBox(height: 16.h),
              // --- Tombol Aksi ---
              SizedBox(
                height: 38.h,
                child: GradientElevatedButton(
                  contentPadding: const EdgeInsets.all(0),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Okay',
                    style: GoogleFonts.poppins(
                      fontSize: 12, 
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF292929),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
