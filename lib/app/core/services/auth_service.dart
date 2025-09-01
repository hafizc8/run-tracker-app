import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/enums/http_method_enum.dart';
import 'package:zest_mobile/app/core/models/forms/forgot_password_form.dart';
import 'package:zest_mobile/app/core/models/forms/login_form.dart';
import 'package:zest_mobile/app/core/models/forms/registe_create_profile_form.dart';
import 'package:zest_mobile/app/core/models/forms/register_form.dart';
import 'package:zest_mobile/app/core/models/forms/reset_password_form.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/services/fcm_service.dart';
import 'package:zest_mobile/app/core/services/storage_service.dart';
import 'package:zest_mobile/app/core/values/app_constants.dart';
import 'package:zest_mobile/app/core/values/storage_keys.dart';

class AuthService {
  final ApiService _apiService;
  final FcmService _fcmService = FcmService();
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
      final fcmToken = await _fcmService.getFcmToken();

      if (fcmToken != null) {
        form = form.copyWith(fcmToken: fcmToken);
      }

      final response = await _apiService.request(
        path: AppConstants.login,
        method: HttpMethod.post,
        data: form.toJson(),
      );

      // store token to local
      await sl<StorageService>()
          .write(StorageKeys.token, response.data['data']['token']);

      await sl<StorageService>().write(StorageKeys.lastLoginTimeStamp, DateTime.now().toIso8601String());

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> register(RegisterFormModel form) async {
    try {
      final fcmToken = await _fcmService.getFcmToken();

      if (fcmToken != null) {
        form = form.copyWith(fcmToken: fcmToken);
      }

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
        path: AppConstants.me,
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
        await sl<StorageService>().remove(StorageKeys.detailUser);
      }

      return response.data['success'];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception("cancelled_by_user");

      final googleAuth = await googleUser.authentication;

      final fcmToken = await _fcmService.getFcmToken();

      final response = await _apiService.request(
        path: AppConstants.loginWithGoogle,
        method: HttpMethod.post,
        data: {
          "access_token": googleAuth.accessToken,
          "fcm_token": fcmToken ?? ''
        },
      );

      await sl<StorageService>().write(
        StorageKeys.token,
        response.data['data']['token'],
      );

      await sl<StorageService>().write(StorageKeys.lastLoginTimeStamp, DateTime.now().toIso8601String());

      return response.data['success'] ?? false;
    } on FirebaseAuthException catch (e) {
      throw Exception("firebase_${e.code}");
    } on PlatformException catch (e) {
      throw Exception("platform_${e.code}");
    } catch (e) {
      throw Exception("unknown_${e.toString()}");
    }
  }
}
