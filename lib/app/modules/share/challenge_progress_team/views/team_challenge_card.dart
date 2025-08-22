import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zest_mobile/app/core/shared/helpers/number_helper.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

class TeamChallengeCard extends StatelessWidget {
  final int rank;
  final String teamName;
  final int totalSteps;
  final List<String> memberImageUrls;
  final Color? teamColor;

  const TeamChallengeCard({
    super.key,
    required this.rank,
    required this.teamName,
    required this.totalSteps,
    required this.memberImageUrls,
    this.teamColor, // Warna default jika tidak ditentukan
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFirstRank = rank == 1;

    return Container(
      margin: isFirstRank ? EdgeInsets.only(bottom: 8.h) : EdgeInsets.only(right: 14.w, left: 14.w, bottom: 8.h),
      // Dekorasi utama untuk border luar dan shadow
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0), // Lebar border gradien
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: Container(
            child: Column(
              children: [
                // --- Section Title (Abu Gelap) ---
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isFirstRank ? (teamColor ?? const Color(0xFF0BBE48)) : const Color(0xFFB2B2B2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                          children: [
                            TextSpan(text: '#$rank '),
                            TextSpan(text: teamName),
                          ],
                        ),
                      ),
                      Text(
                        '${NumberHelper().formatNumberToKWithComma(totalSteps)} Steps',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // --- Section Content (Abu Muda) ---
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: isFirstRank ? (teamColor != null ? teamColor?.withOpacity(0.85) : const Color(0xFF15DE5A)) : const Color(0xFFCBCBCB),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: _buildParticipantAvatars(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget untuk menampilkan tumpukan avatar anggota tim
  Widget _buildParticipantAvatars() {
    // Batasi jumlah avatar yang ditampilkan, misal maksimal 10
    final displayUrls = memberImageUrls.take(10).toList();

    return SizedBox(
      height: 40.r, // Atur tinggi area tumpukan avatar
      child: Stack(
        children: List.generate(displayUrls.length, (index) {
          return Positioned(
            // Geser setiap avatar ke kanan
            left: (index * 25.0).w,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: teamColor ?? Colors.white, width: 2), // Border berwarna
              ),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: displayUrls[index],
                    width: 32.r,
                    height: 32.r,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ShimmerLoadingCircle(size: 32.r),
                    errorWidget: (context, url, error) => Container(
                      width: 16.r,
                      height: 16.r,
                      child: CircleAvatar(
                        radius: 16.r,
                        backgroundImage: const AssetImage('assets/images/empty_profile.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
