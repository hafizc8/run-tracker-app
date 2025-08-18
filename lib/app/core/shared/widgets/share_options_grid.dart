import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShareOptionsGrid extends StatelessWidget {
  // Callback yang akan dipanggil saat salah satu opsi ditekan,
  // membawa label dari opsi tersebut (misal: "Whatsapp").
  final Function(String label) onOptionTap;

  const ShareOptionsGrid({super.key, required this.onOptionTap});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> shareOptions = [
      {'icon': 'assets/icons/ic_share_whatsapp.svg', 'label': 'Whatsapp'},
      {'icon': 'assets/icons/ic_share_instagram.svg', 'label': 'Instagram'},
      {'icon': 'assets/icons/Twitter-X-Icon-PNG.svg', 'label': 'X'},
      {'icon': 'assets/icons/ic_share_link.svg', 'label': 'Link'},
      {'icon': 'assets/icons/ic_share_download.svg', 'label': 'Download'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Share to your',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              color: const Color(0xFF9B9B9B),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 0.8,
          ),
          itemCount: shareOptions.length,
          itemBuilder: (context, index) {
            final option = shareOptions[index];
            return GestureDetector(
              onTap: () => onOptionTap(option['label']!),
              child: _buildShareIcon(context, option['icon']!, option['label']!),
            );
          },
        ),
      ],
    );
  }

  Widget _buildShareIcon(BuildContext context, String iconAsset, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(iconAsset, width: 36.w, height: 36.h),
        SizedBox(height: 8.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 11.sp,
            color: const Color(0xFF9B9B9B),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
