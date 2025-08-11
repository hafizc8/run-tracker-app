import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zest_mobile/app/modules/privacy_policy/controllers/privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Color(0xFFA5A5A5),
              ),
        ),
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
      body: WebViewWidget(controller: controller.webViewController),
    );
  }
}
