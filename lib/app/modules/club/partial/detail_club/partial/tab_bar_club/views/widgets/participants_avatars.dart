import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';

// ignore: must_be_immutable
class ParticipantsAvatars extends StatelessWidget {
  ParticipantsAvatars({super.key, required this.imageUrls, this.avatarSize = 35, this.overlapOffset = 23, this.maxVisible = 10});

  final List<String> imageUrls;

  double avatarSize = 35;
  double overlapOffset = 23;
  int maxVisible = 10;

  @override
  Widget build(BuildContext context) {
    final displayCount = imageUrls.length > maxVisible
        ? maxVisible
        : imageUrls.length;

    final extraCount = imageUrls.length - maxVisible;

    return SizedBox(
      height: avatarSize + 2, // 2 for padding
      width: displayCount * overlapOffset + avatarSize,
      child: Stack(
        children: List.generate(displayCount, (index) {
          // Last avatar is the "+X"
          if (index == maxVisible - 1 && imageUrls.length > maxVisible) {
            return Positioned(
              left: index * overlapOffset,
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    '+${extraCount > 999 ? '999' : extraCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }

          return Positioned(
            left: index * overlapOffset,
            child: Container(
              width: avatarSize,
              height: avatarSize,
              padding: const EdgeInsets.all(0),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  width: avatarSize,
                  height: avatarSize,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      ShimmerLoadingCircle(size: avatarSize),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/empty_profile.png'),
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
