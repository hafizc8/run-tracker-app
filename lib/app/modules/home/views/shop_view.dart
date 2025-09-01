import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zest_mobile/app/core/models/model/shop_provider_model.dart';
import 'package:zest_mobile/app/core/shared/theme/input_decoration_theme.dart';
import 'package:zest_mobile/app/core/shared/widgets/shimmer_loading_list.dart';
import 'package:zest_mobile/app/modules/home/controllers/shop_controller.dart';

class ShopView extends GetView<ShopController> {
  const ShopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/icons/svgviewer-output.svg',
        ),
        automaticallyImplyLeading: false,
        elevation: 4,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoadingList(
                itemCount: 1,
                itemHeight: 200,
              ),
              ShimmerLoadingList(
                itemCount: 1,
                itemHeight: 100,
              ),
            ],
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: controller.shopProviderModel.value?.sliders.map((e) {
                      return GradientBorderImageCard(
                        imageUrl: e,
                      );
                    }).toList() ??
                    [],
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                'Visit Our Store',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      color: Color(0xFFA5A5A5),
                    ),
              ),
              const SizedBox(
                height: 32,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: ((context, index) {
                    Link? link =
                        controller.shopProviderModel.value?.links[index];
                    return GestureDetector(
                      onTap: () => controller.openLink(link?.link ?? ''),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF2E2E2E),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3B3B3B),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: link?.imageUrl ?? '',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey.shade800,
                                    highlightColor: Colors.grey.shade700,
                                    child: const SizedBox.shrink(),
                                  ),
                                  errorWidget: (context, url, error) => Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image,
                                            size: 64.r, color: Colors.grey),
                                        SizedBox(height: 8.h),
                                        const Text('Image Placeholder',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFFA2FF00),
                                        Color(0xFF00FF7F),
                                      ],
                                    ).createShader(Rect.fromLTWH(
                                            0, 0, bounds.width, bounds.height)),
                                    child: Text(
                                      'Buy On ${link?.title ?? ''}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.sp,
                                          ),
                                    ),
                                  ),
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFA2FF00),
                                        Color(0xFF00FF7F),
                                      ],
                                    ).createShader(
                                      Rect.fromLTWH(
                                          0, 0, bounds.width, bounds.height),
                                    ),
                                    child: Icon(
                                      Icons.chevron_right,
                                      size: 25.h,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    );
                  }),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 16,
                      ),
                  itemCount:
                      controller.shopProviderModel.value?.links.length ?? 0),
            ],
          ),
        );
      }),
    );
  }
}

class GradientBorderImageCard extends StatelessWidget {
  const GradientBorderImageCard({
    super.key,
    required this.imageUrl,
    this.borderWidth = 1,
    this.borderRadius = 16,
    this.height = 176,
  });

  final String imageUrl;
  final double borderWidth;
  final double borderRadius;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      // BORDER GRADIENT
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: kDefaultGradientBorderColors,
        ),
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      padding: EdgeInsets.all(borderWidth.w), // lebar border
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r + borderWidth.w),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
