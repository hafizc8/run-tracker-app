import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_circle.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/main_profile/controllers/badges_controller.dart';

class BadgesView extends GetView<BadgesController> {
  const BadgesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Badges',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Color(0xFFA5A5A5),
              ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 4,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.chevron_left,
            size: 48,
            color: Color(0xFFA5A5A5),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ShimmerLoadingList(
            itemCount: 10,
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: controller.badges.length,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xFF2E2E2E),
            ),
            child: Column(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: controller.badges[index].badgeIconUrl ?? '',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const ShimmerLoadingCircle(size: 50),
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 32,
                      backgroundImage:
                          AssetImage('assets/images/empty_profile.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  controller.badges[index].badgeName ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
