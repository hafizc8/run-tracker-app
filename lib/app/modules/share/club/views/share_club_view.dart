import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/share_options_grid.dart';
import 'package:zest_mobile/app/modules/share/club/controllers/share_club_controller.dart';
import 'package:zest_mobile/app/modules/share/club/views/share_club_card.dart';

class ShareClubView extends GetView<ShareClubController> {
  const ShareClubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: darkColorScheme.surface,
      body: SingleChildScrollView(
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        
            return Column(
              children: [
                ShareClubCard(
                  clubModel: controller.clubModel,
                ),
            
                SizedBox(height: 24.h),
                ShareOptionsGrid(
                  onOptionTap: (String label) async {
                    await controller.shareTo(label);
                  },
                ),
                SizedBox(height: 24.h),
              ],
            );
          }
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.chevron_left,
          color: Theme.of(context).colorScheme.onBackground,
          size: 35,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'Share',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9B9B9B),
        ),
      ),
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.3),
      surfaceTintColor: darkColorScheme.surface,
      backgroundColor: darkColorScheme.surface,
    );
  }

  Widget _buildPlaceholder({required BuildContext context, required String title, required String subtitle}) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 11.sp,
            color: const Color(0xFF9B9B9B),
          ),
        ),
        const SizedBox(height: 4),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFA2FF00), Color(0xFF00FF7F)],
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white, // Teks harus putih agar shader terlihat
            ),
          ),
        ),
      ],
    );
  }
}