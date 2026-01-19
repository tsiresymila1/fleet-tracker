import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/tracking_repository.dart';
import '../../presentation/bloc/auth_bloc.dart';
import '../../presentation/bloc/tracking_bloc.dart';
import '../../presentation/bloc/settings_bloc.dart';
import '../database/database.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Database
  getIt.registerLazySingleton(() => AppDatabase());

  // Dio
  final dio = Dio(BaseOptions(
    baseUrl: 'https://fleet-move-tracker.vercel.app/api',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));
  
  // Add interceptors for auth headers
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Add device auth headers if available
      final authBloc = getIt.isRegistered<AuthBloc>() ? getIt<AuthBloc>() : null;
      if (authBloc != null) {
        authBloc.state.mapOrNull(
          authorized: (state) {
            options.headers['X-DEVICE-ID'] = state.identity.deviceId;
            options.headers['X-DEVICE-KEY'] = state.identity.secretKey;
          },
        );
      }
      handler.next(options);
    },
  ));
  
  getIt.registerLazySingleton(() => dio);

  // API Client
  getIt.registerLazySingleton(() => ApiClient(getIt<Dio>()));

  // Repositories
  getIt.registerLazySingleton(() => AuthRepository(getIt<ApiClient>()));
  getIt.registerLazySingleton(() => TrackingRepository(
        getIt<ApiClient>(),
        getIt<AppDatabase>(),
      ));

  // BLoCs
  getIt.registerLazySingleton(() => AuthBloc(getIt<AuthRepository>()));
  getIt.registerFactory(() => TrackingBloc());
  getIt.registerFactory(() => SettingsBloc());
}
