// app/core/services/fcm_service.dart

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/post_model.dart';
import 'package:zest_mobile/app/core/models/model/user_mini_model.dart';
import 'package:zest_mobile/app/core/services/post_service.dart';
import 'package:zest_mobile/app/modules/social/controllers/post_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_action_controller.dart';
import 'package:zest_mobile/app/modules/social/views/partial/for_you_tab/event/controllers/event_controller.dart';
import 'package:zest_mobile/app/routes/app_routes.dart';

// ✨ PENTING: Fungsi ini harus berada di luar kelas (top-level function)
// agar bisa dijalankan oleh background isolate.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // PENTING: Lakukan inisialisasi dasar jika perlu
  await Firebase.initializeApp();
  
  print("--- Handling a background message: ${message.messageId}");
  
  // Ambil data dari payload
  final String? title = message.data['title'];
  final String? body = message.data['body'];

  if (title != null && body != null) {
    // Buat dan tampilkan notifikasi lokal
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    
    // Konfigurasi Android
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'high_importance_channel', 
            'High Importance Notifications',
            channelDescription: 'Channel untuk notifikasi penting.',
            importance: Importance.max,
            priority: Priority.high);
            
    // Konfigurasi iOS
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
        
    // Tampilkan notifikasi
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }
}

class FcmService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  static final Completer<void> _appReadyCompleter = Completer<void>();
  static Future<void> get appIsReady => _appReadyCompleter.future;

  static void markAppAsReady() {
    // Cek jika completer belum selesai untuk menghindari error
    if (!_appReadyCompleter.isCompleted) {
      _appReadyCompleter.complete();
      print("✅ AppModule is ready! FCM can now navigate.");
    }
  }

  Future<void> initNotifications() async {
    // 1. Minta izin notifikasi dari pengguna
    await _firebaseMessaging.requestPermission();

    // 2. Dapatkan FCM Token
    final fcmToken = await _firebaseMessaging.getToken();
    print("FCM Token: $fcmToken");
    // 3. Atur listener untuk notifikasi
    _initPushNotifications();
  }

  Future<void> _initPushNotifications() async {
    // Inisialisasi notifikasi lokal untuk foreground
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      // Callback saat notifikasi lokal ditekan
      onDidReceiveNotificationResponse: (response) async {
        if (response.payload != null) {
          final Map<String, dynamic> data = jsonDecode(response.payload!);
          // Buat RemoteMessage tiruan untuk ditangani oleh _handleMessage
          final message = RemoteMessage(data: data.map((key, value) => MapEntry(key, value.toString())));
          await _handleMessage(message);
        }
      },
    );

    // 1. Saat Aplikasi Ditutup (Terminated)
    // getInitialMessage() akan memeriksa apakah aplikasi dibuka dari notifikasi.
    FirebaseMessaging.instance.getInitialMessage().then(_handleMessage);

    // 2. Saat Aplikasi di Background
    // Listener ini akan aktif saat pengguna menekan notifikasi ketika
    // aplikasi sedang di background (tapi tidak terminated).
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // 3. Saat Aplikasi di Foreground
    // Listener ini akan aktif saat notifikasi masuk ketika pengguna
    // sedang membuka aplikasi.
    FirebaseMessaging.onMessage.listen(_showLocalNotification);
    
    // 4. Mendaftarkan handler untuk pesan data-only di background.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Fungsi untuk menangani aksi saat notifikasi ditekan
  Future<void> _handleMessage(RemoteMessage? message) async {
    if (message == null) return;

    await FcmService.appIsReady;

    print("App is ready, proceeding with navigation for data: ${message.data}");

    print("Handling a background message: $message");

    final data = message.data;

    // --- Kategori: Chat ---
    if (data.containsKey('chat.relateable_type')) {
      final type = data['chat.relateable_type'];
      final id = data['chat.relateable_id'];
      final title = data['title'];

      if (id == null || title == null) return;

      switch (type) {
        case 'user':
          Get.toNamed(
            AppRoutes.userChat,
            arguments: UserMiniModel(
              id: id,
              name: title,
              imageUrl: '',
            ),
          );
          break;
        case 'club':
          Get.toNamed(AppRoutes.clubChat, arguments: {
            'id': id,
            'title': title,
            'imgUrl': '',
          });
          break;
        case 'event':
          Get.toNamed(AppRoutes.eventChat, arguments: {
            'id': id,
            'title': title,
          });
          break;
      }
    }

    // --- Kategori: Undangan Event ---
    else if (data.containsKey('event.id')) {
      final eventId = data['event.id'];
      if (eventId == null) return;

      Get.put(EventController());
      Get.put(EventActionController());
      Get.toNamed(AppRoutes.socialYourPageEventDetail, arguments: {'eventId': eventId});
    }

    // --- Kategori: Follow User ---
    else if (data.containsKey('user.id')) {
      final userId = data['user.id'];
      if (userId == null) return;
      Get.toNamed(AppRoutes.profileUser, arguments: userId);
    }

    // --- Kategori: Undangan Club ---
    else if (data.containsKey('club.id')) {
      final clubId = data['club.id'];
      if (clubId == null) return;
      Get.toNamed(AppRoutes.previewClub, arguments: clubId);
    }

    // --- Kategori: Undangan Challenge ---
    else if (data.containsKey('challenge.id')) {
      final challengeId = data['challenge.id'];
      if (challengeId == null) return;
      Get.toNamed(AppRoutes.challengedetails, arguments: {"challengeId": challengeId});
    }

    // --- Kategori: Like atau Komentar Postingan ---
    else if (data.containsKey('post.id')) {
      final postId = data['post.id'];
      if (postId == null) return;

      goToDetailPost(postId: postId);
    }
  }

  void goToDetailPost({required String postId}) async {
    final _postService = sl<PostService>();
    
    final postController = Get.find<PostController>();

    final PostModel post = await _postService.getDetail(postId: postId);

    postController.postDetail.value = post;

    postController.goToDetail(postId: post.id!);
  }

  /// Menampilkan notifikasi lokal saat aplikasi di foreground
  Future<void> _showLocalNotification(RemoteMessage message) async {
    // Ambil data dari payload 'data'
    final String? title = message.data['title'];
    final String? body = message.data['body'];
    final Map<String, dynamic> payloadData = message.data;
    
    if (title == null || body == null) return;

    // Konfigurasi detail notifikasi untuk Android
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel', // ID channel
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );

    // Konfigurasi detail notifikasi untuk iOS
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Tampilkan notifikasi
    await _localNotifications.show(
      message.hashCode,
      title,
      body,
      notificationDetails,
      payload: jsonEncode(payloadData), // Kirim data payload
    );
  }

  Future<String?> getFcmToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");
      return token;
    } catch (e) {
      print("Error getting FCM token: $e");
      return null;
    }
  }
}