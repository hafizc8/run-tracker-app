import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/model/badge_model.dart';
import 'package:zest_mobile/app/core/models/model/shop_provider_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';

class ShopService {
  final ApiService _apiService;
  ShopService(this._apiService);

  Future<ShopProviderModel> getShop() async {
    try {
      final response = await _apiService.request(
        path: AppConstants.shop,
        method: HttpMethod.get,
      );

      return ShopProviderModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
}
