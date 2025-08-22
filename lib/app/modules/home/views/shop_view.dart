import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
                itemCount: 3,
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
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF2E2E2E),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Flexible(child: Text('data')),
                          Flexible(child: Text('data')),
                        ],
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
    this.borderWidth = 3,
    this.borderRadius = 16,
    this.height = 200,
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
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: EdgeInsets.all(borderWidth), // lebar border
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - borderWidth),
        child: Container(
          height: height,
          // BACKGROUND IMAGE
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          // OPTIONAL: gradient overlay supaya teks kebaca
          foregroundDecoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black54, Colors.transparent],
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(12),
          child: const Text(
            'Judul di atas gambar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
