import 'package:get_it/get_it.dart';
import 'package:zest_mobile/app/core/dio/dio_client.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/badge_service.dart';
import 'package:zest_mobile/app/core/services/challenge_service.dart';
import 'package:zest_mobile/app/core/services/event_service.dart';
import 'package:zest_mobile/app/core/services/club_service.dart';
import 'package:zest_mobile/app/core/services/location_service.dart';
import 'package:zest_mobile/app/core/services/log_service.dart';
import 'package:zest_mobile/app/core/services/post_service.dart';
import 'package:zest_mobile/app/core/services/record_activity_service.dart';
import 'package:zest_mobile/app/core/services/storage_service.dart';
import 'package:zest_mobile/app/core/services/user_service.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton(() => StorageService());
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => ApiService(sl<DioClient>()));
  sl.registerLazySingleton(() => AuthService(sl<ApiService>()));
  sl.registerLazySingleton(() => UserService(sl<ApiService>()));
  sl.registerLazySingleton(() => LocationService(sl<ApiService>()));
  sl.registerLazySingleton(() => PostService(sl<ApiService>()));
  sl.registerLazySingleton(() => EventService(sl<ApiService>()));
  sl.registerLazySingleton(() => ClubService(sl<ApiService>()));
  sl.registerLazySingleton(() => BadgeService(sl<ApiService>()));
  sl.registerLazySingleton(() => ChallengeService(sl<ApiService>()));
  sl.registerLazySingleton(() => RecordActivityService(sl<ApiService>()));
  sl.registerSingletonAsync<LogService>(() => LogService().init());
}
