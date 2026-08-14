import 'package:flutter/foundation.dart';
import '../cache/cache_helper.dart';
import '../cache/cache_keys.dart';

abstract final class TokenUtils {
  const TokenUtils._();

  /// Safely extracts the access token string from root or nested maps.
  static String? extractAccessToken(dynamic data) {
    if (data is! Map) return null;

    var token = data['accessToken'] ??
        data['access_token'] ??
        data['token'] ??
        data['jwt'];
    if (token != null && token.toString().isNotEmpty) {
      return token.toString();
    }

    if (data['data'] is Map) {
      final subMap = data['data'] as Map;
      token = subMap['accessToken'] ??
          subMap['access_token'] ??
          subMap['token'] ??
          subMap['jwt'];
      if (token != null && token.toString().isNotEmpty) {
        return token.toString();
      }
    }

    if (data['tokens'] is Map) {
      final subMap = data['tokens'] as Map;
      token = subMap['accessToken'] ??
          subMap['access_token'] ??
          subMap['token'] ??
          subMap['jwt'];
      if (token != null && token.toString().isNotEmpty) {
        return token.toString();
      }
    }

    return null;
  }

  /// Safely extracts the refresh token string from root or nested maps.
  static String? extractRefreshToken(dynamic data) {
    if (data is! Map) return null;

    var token = data['refreshToken'] ?? data['refresh_token'];
    if (token != null && token.toString().isNotEmpty) {
      return token.toString();
    }

    if (data['data'] is Map) {
      final subMap = data['data'] as Map;
      token = subMap['refreshToken'] ?? subMap['refresh_token'];
      if (token != null && token.toString().isNotEmpty) {
        return token.toString();
      }
    }

    if (data['tokens'] is Map) {
      final subMap = data['tokens'] as Map;
      token = subMap['refreshToken'] ?? subMap['refresh_token'];
      if (token != null && token.toString().isNotEmpty) {
        return token.toString();
      }
    }

    return null;
  }

  /// Exception-safe lookup for access token. Checks secure storage first,
  /// falling back to SharedPreferences.
  static Future<String?> getAccessToken(CacheHelper cache) async {
    try {
      final secureToken = await cache.getSecureData(key: CacheKeys.accessToken);
      if (secureToken != null && secureToken.isNotEmpty) {
        return secureToken;
      }
    } catch (e) {
      debugPrint('TokenUtils: Secure storage read error for accessToken: $e');
    }
    return cache.getString(key: CacheKeys.accessToken);
  }

  /// Exception-safe lookup for refresh token. Checks secure storage first,
  /// falling back to SharedPreferences.
  static Future<String?> getRefreshToken(CacheHelper cache) async {
    try {
      final secureToken = await cache.getSecureData(key: CacheKeys.refreshToken);
      if (secureToken != null && secureToken.isNotEmpty) {
        return secureToken;
      }
    } catch (e) {
      debugPrint('TokenUtils: Secure storage read error for refreshToken: $e');
    }
    return cache.getString(key: CacheKeys.refreshToken);
  }

  /// Persists access token and optional refresh token to both SharedPreferences
  /// and FlutterSecureStorage with exception safety.
  static Future<void> saveTokens(
    CacheHelper cache, {
    required String accessToken,
    String? refreshToken,
  }) async {
    await cache.saveData(key: CacheKeys.accessToken, value: accessToken);
    try {
      await cache.saveSecureData(key: CacheKeys.accessToken, value: accessToken);
    } catch (e) {
      debugPrint('TokenUtils: Secure storage save error for accessToken: $e');
    }

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await cache.saveData(key: CacheKeys.refreshToken, value: refreshToken);
      try {
        await cache.saveSecureData(
          key: CacheKeys.refreshToken,
          value: refreshToken,
        );
      } catch (e) {
        debugPrint('TokenUtils: Secure storage save error for refreshToken: $e');
      }
    }
  }

  /// Clears stored access and refresh tokens from both storage systems.
  static Future<void> clearTokens(CacheHelper cache) async {
    await cache.deleteData(key: CacheKeys.accessToken);
    await cache.deleteData(key: CacheKeys.refreshToken);
    try {
      await cache.deleteSecureData(key: CacheKeys.accessToken);
      await cache.deleteSecureData(key: CacheKeys.refreshToken);
    } catch (e) {
      debugPrint('TokenUtils: Secure storage clear error: $e');
    }
  }
}
