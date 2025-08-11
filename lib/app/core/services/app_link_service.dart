// file: app/core/services/app_link_service.dart
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';

class AppLinkService extends GetxService {
  final _appLinks = AppLinks();
  
  // State untuk menyimpan URI deep link awal
  Uri? initialUri;

  Future<AppLinkService> init() async {
    // Ambil link awal yang mungkin membuka aplikasi
    initialUri = await _appLinks.getInitialLink();
    print("Initial App Link: $initialUri");
    return this;
  }
}