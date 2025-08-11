import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';

class PrivacyPolicyController extends GetxController {
  late final WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(AppConstants.baseUrlPrivacy));
  }
}
