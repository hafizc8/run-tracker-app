import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:zest_mobile/app/core/models/model/leaderboard_user_model.dart';
import 'package:zest_mobile/app/core/shared/theme/color_schemes.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

/// Widget utama untuk menampilkan 3 walker teratas dalam format podium.
class Top3WalkersList extends StatelessWidget {
  final List<LeaderboardUserModel> topWalkers;

  const Top3WalkersList({super.key, required this.topWalkers});

  @override
  Widget build(BuildContext context) {
    // Cari walker untuk setiap posisi podium
    final firstPlace = topWalkers.firstWhereOrNull((w) => w.rank == 1);
    final secondPlace = topWalkers.firstWhereOrNull((w) => w.rank == 2);
    final thirdPlace = topWalkers.firstWhereOrNull((w) => w.rank == 3);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Peringkat 2 (Kiri)
          if (secondPlace != null) _PodiumWalkerProfile(walker: secondPlace),

          SizedBox(width: 16.w),

          // Peringkat 1 (Tengah)
          if (firstPlace != null)
            _PodiumWalkerProfile(
              walker: firstPlace,
              isFirstPlace: thirdPlace == null ? (secondPlace == null ? true : false) : true,
            )
          else
            const Expanded(child: SizedBox()),

          SizedBox(width: 16.w),

          // Peringkat 3 (Kanan)
          if (thirdPlace != null) _PodiumWalkerProfile(walker: thirdPlace)
        ],
      ),
    );
  }
}

/// Widget internal untuk menampilkan satu profil walker di podium.
class _PodiumWalkerProfile extends StatelessWidget {
  final LeaderboardUserModel walker;
  final bool isFirstPlace;

  const _PodiumWalkerProfile({
    required this.walker,
    this.isFirstPlace = false,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan ukuran dinamis berdasarkan peringkat
    final double avatarSize = isFirstPlace ? 90.r : 70.r;
    final double rankBadgeSize = isFirstPlace ? 40.r : 29.r;
    final double rankFontSize = isFirstPlace ? 20.sp : 14.sp;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stack untuk menumpuk avatar dan lencana peringkat
          Stack(
            clipBehavior: Clip.none, // Izinkan lencana keluar dari batas
            alignment: Alignment.center,
            children: [
              // Lingkaran border dengan gradien
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: darkColorScheme.primary
                ),
              ),
              // Gambar profil pengguna
              Padding(
                padding: const EdgeInsets.all(4.0), // Jarak untuk ketebalan border
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: walker.imageUrl ?? '',
                    width: avatarSize - 3,
                    height: avatarSize - 3,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ShimmerLoadingCircle(size: avatarSize - 8),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: (avatarSize - 8) / 2,
                      backgroundImage: const AssetImage('assets/images/empty_profile.png'),
                    ),
                  ),
                ),
              ),
              // Lencana peringkat (ditempatkan di bawah avatar)
              Positioned(
                bottom: -rankBadgeSize / 2.5,
                child: Container(
                  width: rankBadgeSize,
                  height: rankBadgeSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: darkColorScheme.primary
                  ),
                  child: Center(
                    child: Text(
                      '${walker.rank}',
                      style: GoogleFonts.poppins(
                        fontSize: rankFontSize,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF292929),
                        fontStyle: FontStyle.italic,
                      )
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: rankBadgeSize / 2 + 4.h), // Spasi agar teks tidak tertutup lencana
          
          // Nama pengguna
          Text(
            walker.name ?? '-',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: const Color(0xFFA5A5A5),
              fontSize: 12,
              fontWeight: FontWeight.w400
            ),
          ),
          
          // Jumlah langkah
          Text(
            NumberFormat('#,###', "id_ID").format(walker.totalStep ?? 0),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: const Color(0xFF656565),
              fontSize: 12,
              fontWeight: FontWeight.w400
            ),
          ),
        ],
      ),
    );
  }
}
