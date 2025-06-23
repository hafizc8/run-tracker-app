import 'app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/activity_data_point_model.dart';
import 'package:zest_mobile/app/core/services/background_service.dart' as bg;

void main() async {
  // 1. Inisialisasi dasar Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi service-service inti (bisa berjalan paralel)
  await Future.wait([
    GetStorage.init(),
    Firebase.initializeApp(),
    // Hive bisa dipisah jika ada dependensi
  ]);

  // 3. Inisialisasi Hive (setelah initFlutter)
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityDataPointAdapter());

  // 4. Inisialisasi Dependency Injection dan Background Service
  setupServiceLocator();
  await initializeService(); // Sekarang hanya mengkonfigurasi service

  // 5. Konfigurasi Crashlytics dan Orientasi Layar
  if (kReleaseMode) { // Hanya aktifkan Crashlytics di mode release
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // 6. Jalankan Aplikasi
  runApp(const App());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  const String notificationChannelId = 'zest_channel';
  const String notificationChannelName = 'Zest Background Service';

  // Inisialisasi plugin notifikasi dan buat channel
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
        notificationChannelId,
        notificationChannelName,
        description: 'Channel ini digunakan untuk melacak aktivitas.',
        importance: Importance.low, // Gunakan low agar tidak ada suara/getar
      ));

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: bg.onStart,
      onBackground: bg.onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: bg.onStart,
      isForegroundMode: true,
      autoStart: false,
      notificationChannelId: notificationChannelId,
      initialNotificationTitle: 'Zest Menunggu',
      initialNotificationContent: 'Aktivitas siap dimulai.',
      foregroundServiceNotificationId: 888,
      foregroundServiceTypes: [
        AndroidForegroundType.location,
        AndroidForegroundType.health,
      ],
    ),
  );

  service.on('update_notification').listen((data) {
    if (data == null) return;

    // Panggil setNotificationInfo dari sini (Dunia UI), ini cara yang benar.
    FlutterLocalNotificationsPlugin().show(
      888,
      data['title'],
      data['content'],
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'zest_channel',
          'Zest Background Service',
          icon: '@mipmap/ic_launcher',
          ongoing: true,
          enableVibration: false,
          playSound: false,
        ),
      ),
    );
  });
}