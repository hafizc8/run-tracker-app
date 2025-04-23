import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/forms/forgot_password_form.dart';
import 'package:zest_mobile/app/core/models/forms/login_form.dart';
import 'package:zest_mobile/app/core/models/forms/registe_create_profile_form.dart';
import 'package:zest_mobile/app/core/models/forms/register_form.dart';
import 'package:zest_mobile/app/core/models/forms/reset_password_form.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/services/storage_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';
import 'package:zest_mobile/app/core/values/storage_keys.dart';

class AuthService {
  final ApiService _apiService;
  AuthService(this._apiService);

  UserModel? get user {
    var data = sl<StorageService>().read(StorageKeys.user);
    if (data != null) {
      return UserModel.fromJson(data);
    }

    return null;
  }

  String? get token => sl<StorageService>().read(StorageKeys.token);

  bool get isAuthenticated => token != null;

  Future<bool> login(LoginFormModel form) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.login,
        method: HttpMethod.post,
        data: form.toJson(),
      );

      // store token to local
      await sl<StorageService>()
          .write(StorageKeys.token, response.data['data']['token']);

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> register(RegisterFormModel form) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.register,
        method: HttpMethod.post,
        data: form.toJson(),
      );

      // store token to local
      await sl<StorageService>()
          .write(StorageKeys.token, response.data['data']['token']);

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> forgotPassword(ForgotPasswordFormModel form) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.forgotPassword,
        method: HttpMethod.post,
        data: form.toJson(),
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> resetPassword(ResetPasswordFormModel form) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.resetPassword,
        method: HttpMethod.post,
        data: form.toJson(),
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> completeProfile(RegisterCreateProfileFormModel form) async {
    try {
      final response = await _apiService.request(
        path: AppConstants.completeProfile,
        method: HttpMethod.post,
        data: form.toJson(),
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> me() async {
    try {
      final response = await _apiService.request(
        path: AppConstants.user,
        method: HttpMethod.get,
      );
      final user = UserModel.fromJson(response.data['data']);
      await sl<StorageService>().write(StorageKeys.user, user.toJson());
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendEmailVerify() async {
    try {
      var response = await _apiService.request(
        path: AppConstants.emailVerify,
        method: HttpMethod.post,
      );

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await _apiService.request(
        path: AppConstants.logout,
        method: HttpMethod.post,
      );

      if (response.data['success']) {
        await sl<StorageService>().remove(StorageKeys.token);
        await sl<StorageService>().remove(StorageKeys.user);
      }

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }
}
