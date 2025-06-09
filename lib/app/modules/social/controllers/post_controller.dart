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
import 'package:zest_mobile/app/core/models/forms/update_post_form.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/models/model/user_model.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/location_service.dart';
import 'package:zest_mobile/app/core/services/post_service.dart';
import 'package:zest_mobile/app/core/shared/helpers/debouncer.dart';
import 'package:zest_mobile/app/modules/social/views/partial/your_page_tab/post/create_post_dialog.dart';
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

  // update post
  var updatePostForm = UpdatePostFormModel().obs;
  var updatePostOriginalForm = UpdatePostFormModel().obs;
  RxBool isLoadingUpdatePost = false.obs;
  RxBool isLoadingLoadUpdatePost = false.obs;

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
      if ((response.pagination.next == null ||
              response.pagination.next!.isEmpty) ||
          response.data.isEmpty ||
          response.data.length < 20) {
        hasReacheMax.value = true;
      }

      // Tambahkan hasil ke list
      posts.addAll(response.data
          .map((e) => e.copyWith(isOwner: e.user?.id == user?.id))
          .toList());

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
    form.value = CreatePostFormModel().copyWith(
        latitude: latLng.value.latitude, longitude: latLng.value.longitude);
    Get.dialog(CreatePostDialog());
  }

  // Pick multiple images and videos.
  dynamic pickMultipleMedia() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: true,
    );

    if (result != null) {
      form.value = form.value
          .copyWith(galleries: result.xFiles.map((e) => File(e.path)).toList());
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

  Future<void> likePost(
      {required String postId,
      int isDislike = 0,
      bool isPostDetail = false}) async {
    try {
      bool resp =
          await _postService.likeDislike(postId: postId, isDislike: isDislike);
      if (resp) {
        // update manual is_liked
        final index = posts.indexWhere((element) => element?.id == postId);
        if (index != -1) {
          final updated = posts[index]!.copyWith(
            isLiked: isDislike == 0,
            likesCount: isDislike == 0
                ? posts[index]!.likesCount! + 1
                : posts[index]!.likesCount! - 1,
          );
          posts[index] = updated;
          if (isDislike == 0) {
            posts[index]!.likes?.add(UserMiniModel(
                id: user?.id ?? '',
                name: user?.name ?? '',
                imageUrl: user?.imageUrl ?? ''));
          } else {
            posts[index]!
                .likes
                ?.removeWhere((element) => element.id == user?.id);
          }
        }

        if (isPostDetail) {
          // update is_liked
          postDetail.value = postDetail.value!.copyWith(
            isLiked: isDislike == 0,
            likesCount: isDislike == 0
                ? postDetail.value!.likesCount! + 1
                : postDetail.value!.likesCount! - 1,
          );

          if (isDislike == 0) {
            postDetail.value?.likes?.add(UserMiniModel(
                id: user?.id ?? '',
                name: user?.name ?? '',
                imageUrl: user?.imageUrl ?? ''));
          } else {
            postDetail.value?.likes
                ?.removeWhere((element) => element.id == user?.id);
          }
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

  Future<void> goToDetail(
      {required String postId, bool isFocusComment = false}) async {
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

      if (isFocusComment) {
        await Future.delayed(const Duration(milliseconds: 500));
        focusToComment();
      }
    }
  }

  dynamic focusToComment() {
    commentFocusNode.requestFocus();
  }

  Future<void> commentPost() async {
    try {
      if (commentTextController.text.isEmpty) {
        return;
      }

      PostModel resp = await _postService.commentReply(
        postId: postDetail.value!.id!,
        content: commentTextController.text,
        parentCommentId: (focusedComment.value != null)
            ? focusedComment.value?.id ?? ''
            : '',
      );

      focusedComment.value = null;
      commentTextController.clear();

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

  Future<void> confirmAndDeletePost(
      {required String postId, bool isPostDetail = false}) async {
    Get.defaultDialog(
      title: 'Delete Post',
      middleText: 'Are you sure to delete this post?',
      textCancel: 'Back',
      textConfirm: 'Yes, delete',
      confirmTextColor: Colors.white,
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.symmetric(vertical: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onConfirm: () {
        if (isPostDetail) {
          Get.back(closeOverlays: true); // close detail page
        }
        Get.back(closeOverlays: true);
        _deletePost(postId: postId);
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

  bool get isValidToUpdate =>
      updatePostOriginalForm.value.isValidToUpdate(updatePostForm.value);

  Future<void> goToEditPost(
      {required String postId, bool isFromDetail = false}) async {
    Get.toNamed(AppRoutes.socialEditPost);

    isLoadingLoadUpdatePost.value = true;

    PostModel response = await _postService.getDetail(postId: postId);

    updatePostForm.value = UpdatePostFormModel(
        id: response.id,
        title: response.title,
        content: response.content,
        currentGalleries: response.galleries,
        isFromDetail: isFromDetail);

    updatePostOriginalForm.value = updatePostForm.value;

    isLoadingLoadUpdatePost.value = false;
  }

  void removeMedia({
    required bool isFromServer,
    Gallery? gallery,
    File? file,
  }) {
    final updatedForm = updatePostForm.value;

    if (isFromServer && gallery != null) {
      // Hapus berdasarkan ID Gallery
      final newCurrentGalleries = (updatedForm.currentGalleries ?? [])
          .where((g) => g.id != gallery.id)
          .toList();

      final newDeletedGalleries =
          List<String>.from(updatedForm.deletedGalleries ?? [])
            ..add(gallery.id ?? '');

      updatePostForm.value = updatedForm.copyWith(
        currentGalleries: newCurrentGalleries,
        deletedGalleries: newDeletedGalleries,
      );
    } else if (!isFromServer && file != null) {
      // Hapus berdasarkan path file lokal
      final newNewGalleries = (updatedForm.newGalleries ?? [])
          .where((f) => f.path != file.path)
          .toList();

      updatePostForm.value = updatedForm.copyWith(
        newGalleries: newNewGalleries,
      );
    }
  }

  dynamic pickMultipleMediaToUpdate() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: true,
    );

    if (result != null) {
      updatePostForm.value = updatePostForm.value.copyWith(
        newGalleries: result.xFiles.map((e) => File(e.path)).toList(),
      );
    }
  }

  Future<void> updatePost() async {
    try {
      isLoadingUpdatePost.value = true;

      PostModel resp = await _postService.update(
          postId: updatePostForm.value.id!, form: updatePostForm.value);
      Get.back(); // close form update

      if (!(updatePostForm.value.isFromDetail ?? false)) {
        await refreshAllPosts();
        Get.snackbar('Success', 'Successfully update post');
      } else {
        postDetail.value = postDetail.value!.copyWith(
          title: resp.title,
          content: resp.content,
          galleries: resp.galleries,
        );
        Get.snackbar('Success', 'Successfully update post');
      }
    } on AppException catch (e) {
      // show error snackbar, toast, etc
      AppExceptionHandlerInfo.handle(e);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingUpdatePost.value = false;
    }
  }
}
