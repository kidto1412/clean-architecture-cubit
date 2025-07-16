import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../network/network_info.dart';
import '../constants/app_constants.dart';
import '../../features/analytics/domain/usecases/get_analytics.dart';
import '../../features/analytics/domain/repositories/analytics_repository.dart';
import '../../features/analytics/data/repositories/analytics_repository_impl.dart';
import '../../features/analytics/data/datasources/analytics_datasource.dart';
import '../../features/analytics/data/datasources/analytics_datasource_impl.dart';
import '../../features/analytics/data/datasources/mock_analytics_datasource.dart';
import '../../features/analytics/presentation/cubit/analytics_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/main_page/presentation/cubit/main_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(() => AnalyticsCubit(getAnalytics: sl()));
  sl.registerFactory(() => HomeCubit());
  sl.registerFactory(() => ProfileCubit());
  sl.registerFactory(() => MainCubit());

  // Use cases
  sl.registerLazySingleton(() => GetAnalytics(sl()));

  // Repository
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources - Using mock for now
  sl.registerLazySingleton<AnalyticsRemoteDataSource>(
    () => MockAnalyticsRemoteDataSource(),
  );
  sl.registerLazySingleton<AnalyticsLocalDataSource>(
    () => AnalyticsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl + AppConstants.apiVersion,
      connectTimeout:
          const Duration(milliseconds: AppConstants.connectionTimeout),
      receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    return dio;
  });
}
