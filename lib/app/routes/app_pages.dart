import 'package:get/get.dart';
import 'package:zest_mobile/app/modules/login/bindings/login_binding.dart';
import 'package:zest_mobile/app/modules/login/views/login_view.dart';
import 'package:zest_mobile/app/modules/register/bindings/register_binding.dart';
import 'package:zest_mobile/app/modules/register/views/register_view.dart';
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
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
  ];
}
