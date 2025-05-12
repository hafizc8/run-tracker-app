import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zest_mobile/app/core/exception/app_exception.dart';
import 'package:zest_mobile/app/core/exception/handler/app_exception_handler_info.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/enums/app_exception_enum.dart';
import 'package:zest_mobile/app/core/models/forms/create_post_form.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/location_service.dart';
import 'package:zest_mobile/app/core/services/post_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';
import 'package:zest_mobile/app/modules/social/views/partial/create_post_dialog.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

class PostController extends GetxController {
  final AuthService _authService = sl<AuthService>();
  final LocationService _locationService = sl<LocationService>();
  final postScrollController = ScrollController();
  final PostService _postService = sl<PostService>();
  Rx<LatLng> latLng = const LatLng(-6.2615, 106.8106).obs;
  RxBool isLoadingCreatePost = false.obs;
  RxBool isLoadingGetAllPost = false.obs;
  RxList<PostModel?> posts = <PostModel?>[].obs;
  UserModel? get user => _authService.user;
  var form = CreatePostFormModel().obs;
  var hasReacheMax = false.obs;
  var pagePost = 1;

  // post detail
  Rx<PostModel?> postDetail = Rx<PostModel?>(null);
  RxBool isLoadingPostDetail = false.obs;
  final TextEditingController commentTextController = TextEditingController();
  final FocusNode commentFocusNode = FocusNode();
  Rx<Comment?> focusedComment = Rx<Comment?>(null);
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void onInit() {
    super.onInit();
    getAllPost();
    setCurrentLocation();
    postScrollController.addListener(() {
      final position = postScrollController.position;

      bool isNearBottom = position.pixels >= position.maxScrollExtent - 200;

      _debouncer.run(() {
        if (isNearBottom && !isLoadingGetAllPost.value && !hasReacheMax.value) {
          getAllPost();
        }
      });
    });
  }

  @override
  void onClose() {
    postScrollController.dispose();
    super.onClose();
  }

  Future<void> setCurrentLocation() async {
    latLng.value = await _locationService.getCurrentLocation();
  }

  Future<void> getAllPost() async {
    if (isLoadingGetAllPost.value || hasReacheMax.value) return;

    try {
      isLoadingGetAllPost.value = true;

      final response = await _postService.getAll(page: pagePost);

      // Deteksi akhir halaman dengan lebih akurat
      if ((response.pagination.next == null || response.pagination.next!.isEmpty) || 
          response.data.isEmpty || 
          response.data.length < 20) {
        hasReacheMax.value = true;
      }

      // Tambahkan hasil ke list
      posts.addAll(response.data.map((e) => e.copyWith(isOwner: e.user?.id == user?.id)).toList());

      // Increment page terakhir
      pagePost++;

    } on AppException catch (e) {
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: true,
    );

    if (result != null) {
      form.value = form.value.copyWith(galleries: result.xFiles.map((e) => File(e.path)).toList());
    }
  }

  Future<void> createPost(BuildContext context) async {
    FocusScope.of(context).unfocus();
    isLoadingCreatePost.value = true;
    form.value = form.value.clearErrors();
    try {
      Get.back();
      bool resp = await _postService.create(form.value);
      if (resp) {
        refreshAllPosts();
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

  Future<void> refreshAllPosts() async {
    pagePost = 1;
    hasReacheMax.value = false;
    posts.clear();
    await getAllPost();
  }

  Future<void> likePost({
    required String postId,
    int isDislike = 0,
    bool isPostDetail = false
  }) async {
    try {
      bool resp = await _postService.likeDislike(postId: postId, isDislike: isDislike);
      if (resp) {
        // update manual is_liked
        final index = posts.indexWhere((element) => element?.id == postId);
        if (index != -1) {
          final updated = posts[index]!.copyWith(isLiked: isDislike == 0, likesCount: isDislike == 0 ? posts[index]!.likesCount! + 1 : posts[index]!.likesCount! - 1);
          posts[index] = updated;
        }

        if (isPostDetail) {
          // update is_liked
          postDetail.value = postDetail.value!.copyWith(isLiked: isDislike == 0, likesCount: isDislike == 0 ? postDetail.value!.likesCount! + 1 : postDetail.value!.likesCount! - 1);
        }
      }
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingCreatePost.value = false;
    }
  }

  Future<void> goToDetail({
    required String postId,
  }) async {
    try {
      Get.toNamed(AppRoutes.socialYourPageActivityDetail);

      isLoadingPostDetail.value = true;

      focusedComment.value = null;
      commentTextController.clear();

      PostModel response = await _postService.getDetail(postId: postId);
      postDetail.value = response;
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingPostDetail.value = false;
    }
  }

  Future<void> commentPost() async {
    try {
      PostModel resp = await _postService.commentReply(
        postId: postDetail.value!.id!, 
        content: commentTextController.text, 
        parentCommentId: (focusedComment.value != null) ? focusedComment.value?.id ?? '' : '',
      );
      
      focusedComment.value = null;
      commentTextController.clear();
      Get.snackbar('Success', 'Successfully comment post');

      postDetail.value = resp;

    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingPostDetail.value = false;
    }
  }

  dynamic replyToAndFocusComment({
    required Comment? replyTo,
  }) {
    focusedComment.value = replyTo;
    commentFocusNode.requestFocus();
  }

  dynamic deleteReplyToComment() {
    focusedComment.value = null;
    commentFocusNode.unfocus();
  }

  Future<void> confirmAndDeletePost({required String postId}) async {
    Get.defaultDialog(
      title: 'Delete Post',
      middleText: 'Are you sure to delete this post?',
      textCancel: 'Back',
      textConfirm: 'Yes, delete',
      confirmTextColor: Colors.white,
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.symmetric(vertical: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onConfirm: () async {
        Get.back(closeOverlays: true);
        await _deletePost(postId: postId);
      },
    );
  }

  Future<void> _deletePost({required String postId}) async {
    try {
      bool resp = await _postService.delete(postId: postId);
      if (resp) {
        await refreshAllPosts();
        Get.snackbar('Success', 'Successfully deleted post');
      }
    } on AppException catch (e) {
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

}