// app/core/services/fcm_service.dart

import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  Future<void> initNotifications() async {
    // 1. Minta izin notifikasi dari pengguna
    await _firebaseMessaging.requestPermission();

    // 2. Dapatkan FCM Token
    final fcmToken = await _firebaseMessaging.getToken();
    print("FCM Token: $fcmToken");
    // TODO: Kirim token ini ke server Anda untuk disimpan

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
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final Map<String, dynamic> data = jsonDecode(response.payload!);
          // Buat RemoteMessage tiruan untuk ditangani oleh _handleMessage
          final message = RemoteMessage(data: data.map((key, value) => MapEntry(key, value.toString())));
          _handleMessage(message);
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
  void _handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // Arahkan pengguna ke halaman tertentu berdasarkan data notifikasi
    // Contoh: Get.toNamed('/post-detail', arguments: message.data['postId']);
    print("Handling a background message: ${message.data}");

    // Arahkan pengguna ke halaman tertentu berdasarkan data 'route' di notifikasi
    // Contoh: Backend mengirimkan data: { "route": "/profile", "user_id": "123" }
    if (message.data['route'] != null) {
      // Get.toNamed(message.data['route'], arguments: message.data);
    }
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