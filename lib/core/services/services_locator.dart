import 'package:get_it/get_it.dart';
import 'package:jameya/core/cache/cache_helper.dart';
import 'package:jameya/core/localization/cubit/localization_cubit.dart';
import 'package:dio/dio.dart';
import 'package:jameya/features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/data/ repos/auth_repo.dart';
import '../../features/auth/data/services/auth_service.dart';
import '../network/dio_helper.dart';
// Global GetIt instance for dependency injection
final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final cacheHelper = CacheHelper();

  await cacheHelper.init();

  getIt.registerSingleton<CacheHelper>(cacheHelper);

  getIt.registerLazySingleton<LocaleCubit>(
        () => LocaleCubit(
      getIt<CacheHelper>(),
    ),
  );

  getIt.registerLazySingleton<DioHelper>(
        () => DioHelper(),
  );

  getIt.registerLazySingleton<Dio>(
        () => getIt<DioHelper>().dio,
  );

  getIt.registerLazySingleton<AuthService>(
        () => AuthService(
      getIt<Dio>(),
    ),
  );

  getIt.registerLazySingleton<AuthRepo>(
        () => AuthRepo(
      getIt<AuthService>(),
    ),
  );

  getIt.registerFactory<AuthCubit>(
        () => AuthCubit(
      getIt<AuthRepo>(),
    ),
  );
}