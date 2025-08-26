import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShareOptionsGrid extends StatefulWidget {
  // ✨ Ubah tipe callback menjadi Future<void> untuk menangani async
  final Future<void> Function(String label) onOptionTap;

  const ShareOptionsGrid({super.key, required this.onOptionTap});

  @override
  State<ShareOptionsGrid> createState() => _ShareOptionsGridState();
}

class _ShareOptionsGridState extends State<ShareOptionsGrid> {
  // ✨ State untuk melacak platform mana yang sedang loading
  String? _loadingPlatform;

  final List<Map<String, String>> shareOptions = [
    {'icon': 'assets/icons/ic_share_whatsapp.svg', 'label': 'Whatsapp'},
    {'icon': 'assets/icons/ic_share_instagram.svg', 'label': 'IG Direct'},
    {'icon': 'assets/icons/ic_share_instagram.svg', 'label': 'IG Story'},
    {'icon': 'assets/icons/Twitter-X-Icon-PNG.svg', 'label': 'X'},
    {'icon': 'assets/icons/ic_share_link.svg', 'label': 'Link'},
    {'icon': 'assets/icons/ic_share_download.svg', 'label': 'Download'},
  ];

  @override
  Widget build(BuildContext context) {
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
            final label = option['label']!;
            
            // Cek apakah item ini yang sedang loading
            final bool isLoading = _loadingPlatform == label;

            return GestureDetector(
              onTap: () async {
                // Jangan lakukan apa-apa jika sudah ada proses yang berjalan
                if (_loadingPlatform != null) return;
                
                // ✨ 2. Atur state loading saat ditekan
                setState(() {
                  _loadingPlatform = label;
                });
                
                try {
                  // Jalankan fungsi share yang async
                  await widget.onOptionTap(label);
                } finally {
                  // ✨ 3. Hentikan state loading setelah selesai (baik berhasil maupun gagal)
                  if (mounted) {
                    setState(() {
                      _loadingPlatform = null;
                    });
                  }
                }
              },
              child: _buildShareIcon(context, option['icon']!, label, isLoading),
            );
          },
        ),
      ],
    );
  }

  Widget _buildShareIcon(BuildContext context, String iconAsset, String label, bool isLoading) {
    print('label: $label, isLoading: $isLoading');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 52.r,
          height: 52.r,
          decoration: BoxDecoration(
            color: const Color(0xFF393939),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Lapisan 1: Ikon SVG (selalu ada, menjadi transparan saat loading)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLoading ? 0.0 : 1.0,
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: SvgPicture.asset(
                    iconAsset,
                  ),
                ),
              ),
              
              // Lapisan 2: Loading Indicator (hanya terlihat saat isLoading)
              if (isLoading)
                Padding(
                  padding: EdgeInsets.all(12.r),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                color: const Color(0xFF9B9B9B),
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
