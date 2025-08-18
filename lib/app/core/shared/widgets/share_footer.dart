import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShareFooter extends StatelessWidget {
  const ShareFooter({super.key, this.withShadow = false});

  final bool withShadow;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        height: 48.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
          ),
          // Border radius hanya di sudut bawah
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: withShadow ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Powered by  ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF272727),
              ),
            ),
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(bottom: 5),
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/images/zest_black.svg', 
                  height: 15.h,
                ),
              ),
            ),
            Text(
              ' Download Now!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF272727),
              ),
            ),
          ],
        ),
      ),
    );
  }
}