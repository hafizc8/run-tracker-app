import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/register/bindings/register_binding.dart';
import 'package:zest_mobile/app/modules/register/views/register_view.dart';
import 'package:zest_mobile/app/modules/verification/bindings/verification_binding.dart';
import 'package:zest_mobile/app/modules/verification/views/verification_view.dart';
import 'package:zest_mobile/app/modules/verification_success/bindings/verification_success_binding.dart';
import 'package:zest_mobile/app/modules/verification_success/views/verification_success_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.verification,
      page: () => const VerificationView(),
      binding: VerificationBinding(),
    ),
    GetPage(
      name: AppRoutes.verificationSuccess,
      page: () => const VerificationSuccessView(),
      binding: VerificationSuccessBinding(),
    ),
  ];
}
