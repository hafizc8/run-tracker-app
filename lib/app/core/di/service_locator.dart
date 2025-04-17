import 'package:get_it/get_it.dart';
import 'package:zest_mobile/app/core/dio/dio_client.dart';
import 'package:zest_mobile/app/core/services/api_service.dart';
import 'package:zest_mobile/app/core/services/auth_service.dart';
import 'package:zest_mobile/app/core/services/storage_service.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton(() => StorageService());
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => ApiService(sl<DioClient>()));
  sl.registerLazySingleton(() => AuthService(sl<ApiService>()));
}
