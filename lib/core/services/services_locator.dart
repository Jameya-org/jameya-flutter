import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../cache/cache_helper.dart';
import '../cache/cache_key.dart';
import '../localization/cubit/localization_cubit.dart';
import '../network/dio_helper.dart';
import '../../features/auth/data/repos/auth_repo.dart';
import '../../features/auth/data/services/auth_service.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/profile/data/services/customer_service.dart';
import '../../features/payment/data/services/payment_service.dart';
import '../../features/kyc/data/services/kyc_service.dart';
import '../../features/home/data/services/home_service.dart';
import '../../features/home/data/repos/home_repo.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/cubit/circles_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final cacheHelper = CacheHelper();
  await cacheHelper.init();

  getIt.registerSingleton<CacheHelper>(cacheHelper);

  getIt.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(getIt<CacheHelper>()),
  );

  getIt.registerLazySingleton<DioHelper>(
    () => DioHelper(),
  );

  getIt.registerLazySingleton<Dio>(
    () => getIt<DioHelper>().dio,
  );

  // Restore the persisted auth token so API calls stay authorized
  // after an app restart.
  final savedToken = cacheHelper.getString(key: CacheKey.accessToken);
  if (savedToken != null && savedToken.isNotEmpty) {
    getIt<DioHelper>().setToken(savedToken);
  }

  // Auth
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepo(getIt<AuthService>()),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepo>()),
  );

  // Customer / Profile
  getIt.registerLazySingleton<CustomerService>(
    () => CustomerService(getIt<Dio>()),
  );

  // Payment
  getIt.registerLazySingleton<PaymentService>(
    () => PaymentService(getIt<Dio>()),
  );

  // KYC
  getIt.registerLazySingleton<KycService>(
    () => KycService(getIt<Dio>()),
  );

  // Home
  getIt.registerLazySingleton<HomeService>(
    () => HomeService(getIt<Dio>()),
  );

  getIt.registerLazySingleton<HomeRepo>(
    () => HomeRepo(getIt<HomeService>()),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<HomeRepo>()),
  );

  getIt.registerFactory<CirclesCubit>(
    () => CirclesCubit(getIt<HomeRepo>()),
  );
}