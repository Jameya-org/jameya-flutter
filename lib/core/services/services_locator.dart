import 'package:get_it/get_it.dart';
import 'package:jameya/core/cache/cache_helper.dart';
import 'package:jameya/core/localization/cubit/localization_cubit.dart';

// Global GetIt instance for dependency injection
final getIt = GetIt.instance;

// Registers all app services/dependencies before the app runs
Future<void> setupServiceLocator() async {
  final cacheHelper = CacheHelper();
  await cacheHelper.init();

  // Register CacheHelper as a singleton so the same instance is shared app-wide
  getIt.registerSingleton<CacheHelper>(cacheHelper);

  // LocaleCubit is lazy — created only when first requested
  getIt.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(getIt<CacheHelper>()),
  );
}
