import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/forms/create_post_form.dart';
import 'package:zest_mobile/app/core/models/model/post_all_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/location_service.dart';
import 'package:zest_mobile/app/core/services/post_service.dart';
import 'package:zest_mobile/app/modules/social/views/partial/create_post_dialog.dart';

class PostController extends GetxController {
  final AuthService _authService = sl<AuthService>();
  final PostService _postService = sl<PostService>();
  final LocationService _locationService = sl<LocationService>();
  late ImagePicker _imagePicker;
  Rx<PostAll?> posts = Rx<PostAll?>(null);
  RxBool isLoadingCreatePost = false.obs;
  RxBool isLoadingGetAllPost = false.obs;
  UserModel? get user => _authService.user;
  var form = CreatePostFormModel().obs;
  Rx<LatLng> latLng = const LatLng(-6.2615, 106.8106).obs;

  @override
  void onInit() {
    super.onInit();
    getAllPost();
    _imagePicker = ImagePicker();
    setCurrentLocation();
  }

  Future<void> setCurrentLocation() async {
    latLng.value = await _locationService.getCurrentLocation();
  }

  Future<void> getAllPost() async {
    isLoadingGetAllPost.value = true;
    try {
      posts.value = await _postService.getAll();
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingGetAllPost.value = false;
    }
  }

  dynamic openCreatePostDialog() {
    form.value = CreatePostFormModel().copyWith(latitude: latLng.value.latitude, longitude: latLng.value.longitude);
    Get.dialog(CreatePostDialog());
  }

  // Pick multiple images and videos.
  dynamic pickMultipleMedia() async {
    List<XFile> medias = await _imagePicker.pickMultipleMedia();
    form.value = form.value.copyWith(galleries: medias.map((e) => File(e.path)).toList());

    Get.snackbar("Success", "${medias.length} media selected");
  }

  Future<void> createPost(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isLoadingCreatePost.value = true;
    form.value = form.value.clearErrors();
    try {
      Get.back();
      bool resp = await _postService.create(form.value);
      if (resp) {
        getAllPost();
        Get.snackbar("Success", "Successfully create post");
      }
    } on AppException catch (e) {
      if (e.type == AppExceptionType.validation) {
        form.value = form.value.setErrors(e.errors!);
        return;
      }
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingCreatePost.value = false;
    }
  }
}