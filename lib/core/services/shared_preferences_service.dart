import 'package:jameya/core/cache/cache_helper.dart';
import 'package:jameya/core/cache/cache_key.dart';
import 'package:jameya/core/services/services_locator.dart';

abstract class SharedPreferencesService {
  // --- This methods are used to save and get data about login status ---
  static Future<void> setLoggedIn(bool value) async {
    await getIt<CacheHelper>().saveData(key: CacheKey.isLoggedIn, value: value);
  }

  static bool isLoggedIn() {
    return getIt<CacheHelper>().getData(key: CacheKey.isLoggedIn) ?? false;
  }

  static Future<void> clearAuthData() async {
    await getIt<CacheHelper>().deleteData(key: CacheKey.id);
    await getIt<CacheHelper>().deleteData(key: CacheKey.userDataKey);
    await getIt<CacheHelper>().deleteData(key: CacheKey.isLoggedIn);
  }

  // --- This methods are used to save and get data about onboarding status ---
  static Future<void> onBoardingViewed() async {
    await getIt<CacheHelper>().saveData(
      key: CacheKey.onBoardingViewed,
      value: true,
    );
  }

  static bool isOnBoardingViewed() {
    return getIt<CacheHelper>().getData(key: CacheKey.onBoardingViewed) ??
        false;
  }
}
