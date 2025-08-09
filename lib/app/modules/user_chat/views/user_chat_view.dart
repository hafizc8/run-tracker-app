import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/shared/theme/elevated_btn_theme.dart';
import 'package:zest_mobile/app/core/shared/widgets/chat_bubble.dart';
import 'package:zest_mobile/app/core/shared/widgets/gradient_border_text_field.dart';

class UserChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Chat',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Color(0xFFA5A5A5),
              ),
        ),
        actions: [
          SvgPicture.asset('assets/icons/ic_more_horiz.svg'),
          SizedBox(width: 16),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 4,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.chevron_left,
              color: Color(0xFFA5A5A5),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: GradientBorderTextField(
            hintText: 'Type Something',
            suffixIcon: InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                'assets/icons/ic_send.svg',
              ),
            ),
            onSubmitted: (value) {},
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: kAppDefaultButtonGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Event created",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13.sp,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              "AfifN joined",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    color: Color(0xFF858585),
                  ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              "John Doe joined",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    color: Color(0xFF858585),
                  ),
            ),
          ),
          SizedBox(height: 30),
          ChatBubble(),
        ],
      ),
    );
  }
}
