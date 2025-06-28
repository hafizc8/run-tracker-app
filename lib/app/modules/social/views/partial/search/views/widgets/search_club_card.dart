import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/models/enums/club_privacy_enum.dart';
import 'package:zest_mobile/app/core/models/model/club_model.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_outlined_button.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/modules/social/views/partial/search/controllers/social_search_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

// ignore: must_be_immutable
class SearchClubCard extends StatelessWidget {
  SearchClubCard(
      {super.key,
      required this.club,
      this.cardWidth = 115,
      this.cardHeight = 190,
      this.showDescription = false});

  final ClubModel club;
  final controller = Get.find<SocialSearchController>();
  double cardWidth;
  double cardHeight;
  bool showDescription = false;

  @override
  Widget build(BuildContext context) {
    // 1. Buat Batasan Ukuran di Paling Luar
    // Ini adalah 'kotak' yang diberikan oleh GridView.
    return SizedBox(
      width: cardWidth.w,
      height: cardHeight.h,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: const Color(0xFF474747), // Warna latar belakang utama
        ),
        clipBehavior: Clip.antiAlias, // Mencegah konten keluar dari border radius
        child: Column(
          // 2. Gunakan Column untuk menata dari atas ke bawah
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 3. GUNAKAN EXPANDED
            // Widget ini akan secara fleksibel mengisi semua ruang yang tersisa
            // setelah widget di bawahnya diukur. Inilah kunci utamanya.
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Pusatkan konten secara vertikal
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: club.imageUrl ?? '',
                        width: 50.w,
                        height: 50.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            ShimmerLoadingCircle(size: 50.r),
                        errorWidget: (context, url, error) => CircleAvatar(
                          radius: 50.r,
                          backgroundImage: const AssetImage('assets/images/empty_profile.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      club.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    Visibility(
                      visible: showDescription,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          club.description ?? 'No description',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 10.sp,
                                color: const Color(0xFF9E9E9E),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bagian Member Count (Tidak perlu Expanded)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h), // beri sedikit jarak
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                      ),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            '${NumberHelper().formatNumberToK(club.clubUsersCount ?? 0)} '),
                    TextSpan(
                      text: 'Members',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                          color: const Color(0xFF9E9E9E)),
                    ),
                  ],
                ),
              ),
            ),

            // Bagian Tombol (Tidak perlu Expanded)
            Container(
              // Pindahkan warna latar bagian bawah ke sini
              color: const Color(0xFF3C3C3C),
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              child: SizedBox(
                height: 30.h,
                child: _buildJoinButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method agar build method utama lebih bersih
  Widget _buildJoinButton(BuildContext context) {
    final bool isPublic = club.privacy == ClubPrivacyEnum.public;
    final bool isJoined = club.isJoined ?? false;
    // Dapatkan status loading dari controller
    final bool isLoading = club.id == controller.clubId.value;

    String buttonText = 'Details';
    VoidCallback? onPressed = () {
      Get.toNamed(AppRoutes.previewClub, arguments: club.id);
    };

    if (isPublic) {
      buttonText = isJoined ? 'Joined' : 'Join';
      onPressed = () {
        if (!isJoined) {
          controller.joinClub(club.id ?? '');
        } else {
          Get.snackbar('Info', 'You have already joined this club.');
        }
      };
    }

    return GradientOutlinedButton(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
      onPressed: isLoading ? null : onPressed, // Disable tombol saat loading
      child: Visibility(
        visible: isLoading,
        replacement: Text(
          buttonText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
        ),
        child: const Center(
          child: SizedBox(
              width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
    );
  }
}