import 'package:jameya/core/cache/cache_helper.dart';
import 'package:jameya/core/cache/cache_key.dart';
import 'package:jameya/core/services/services_locator.dart';

abstract class SecureStorageService {
  // --- Save access token and refresh token as secure data ---
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await getIt<CacheHelper>().saveSecureData(
      key: CacheKey.accessToken,
      value: accessToken,
    );
    await getIt<CacheHelper>().saveSecureData(
      key: CacheKey.refreshToken,
      value: refreshToken,
    );
  }

  // --- Get access token ---
  static Future<String?> getAccessToken() async {
    return await getIt<CacheHelper>().getSecureData(key: CacheKey.accessToken);
  }

  // --- Get refresh token ---

  static Future<String?> getRefreshToken() async {
    return await getIt<CacheHelper>().getSecureData(key: CacheKey.refreshToken);
  }

  // --- Delete access token and refresh token ---
  static Future<void> deleteTokens() async {
    await getIt<CacheHelper>().deleteSecureData(key: CacheKey.accessToken);
    await getIt<CacheHelper>().deleteSecureData(key: CacheKey.refreshToken);
  }
}
