import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zest_mobile/app/core/di/service_locator.dart';
import 'package:zest_mobile/app/core/models/model/activity_data_point_model.dart';
import 'app/app.dart';
import 'package:zest_mobile/app/core/services/background_service.dart' as bg;
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  setupServiceLocator();
  await GetStorage.init();
  await initializeService();
  configureNotificationListener();
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityDataPointAdapter());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const App());
}

void configureNotificationListener() {
  final service = FlutterBackgroundService();
  service.on('update').listen((data) {
    if (data == null) return;
    
    final int elapsedTime = data['elapsedTime'] as int;
    final double distance = data['distance'] as double;
    
    final String content = "Durasi: ${bg.formatDuration(elapsedTime)}, Jarak: ${bg.formatDistance(distance)}";
    
    FlutterLocalNotificationsPlugin().show(
      888,
      'Aktivitas Berlangsung',
      content,
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

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // ✨ BARU: Channel ID dan Name untuk notifikasi
  const String notificationChannelId = 'zest_channel';
  const String notificationChannelName = 'Zest Background Service';

  // Buat notification channel
  var channel = const AndroidNotificationChannel(
    notificationChannelId,
    notificationChannelName,
    description: 'Channel ini digunakan untuk melacak aktivitas.',
    importance: Importance.defaultImportance,
  );

  // Inisialisasi plugin notifikasi dan buat channel
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

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
      // ✨ PENTING: Gunakan channel ID dan set detail notifikasi awal di sini
      notificationChannelId: notificationChannelId, 
      initialNotificationTitle: 'Zest Menunggu',
      initialNotificationContent: 'Aktivitas siap dimulai.',
      foregroundServiceNotificationId: 888,
    ),
  );
}
