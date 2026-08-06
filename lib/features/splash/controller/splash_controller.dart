import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/cache/cache_key.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/jwt_decoder.dart';
import '../../auth/data/services/auth_service.dart';

// Controls the typing animation and auth session restoration on the splash screen
class SplashController extends ChangeNotifier {
  final String fullText = 'Jameya.';

  // Characters revealed so far
  String displayedText = '';

  // Whether the logo has slid up
  bool moveUp = false;
  // Whether the language buttons are visible
  bool showButtons = false;

  // Route to navigate to for returning users, based on persisted state.
  // When null, the app shows the language buttons (first-run experience).
  String? destinationRoute;

  // Milliseconds between each character being typed
  static const int typingSpeed = 400;

  Timer? _timer;
  int _currentIndex = 0;

  // Starts the letter-by-letter typing animation
  void startTyping() {
    _currentIndex = 1;
    displayedText = fullText.substring(0, _currentIndex);
    notifyListeners();

    _timer = Timer.periodic(const Duration(milliseconds: typingSpeed), (timer) {
      if (_currentIndex < fullText.length) {
        _currentIndex++;
        displayedText = fullText.substring(0, _currentIndex);
        notifyListeners();

        if (_currentIndex == fullText.length) {
          timer.cancel();

          moveUp = true;
          notifyListeners();

          Future.delayed(const Duration(milliseconds: 400), () {
            _resolveStartupState();
          });
        }
      }
    });
  }

  // Decides the startup destination based on persisted state:
  // 1. Restores saved session (reads tokens from Cache / Secure Storage)
  // 2. Validates access token expiration
  // 3. Automatically refreshes access token if expired and refresh token exists
  // 4. Navigates to Home when session is ready, or Email (Login) if refresh fails
  Future<void> _resolveStartupState() async {
    final cache = getIt<CacheHelper>();
    final authService = getIt<AuthService>();

    String? accessToken = await cache.getSecureData(key: CacheKey.accessToken);
    accessToken ??= cache.getString(key: CacheKey.accessToken);

    String? refreshToken = await cache.getSecureData(key: CacheKey.refreshToken);
    refreshToken ??= cache.getString(key: CacheKey.refreshToken);

    final onboardingSeen =
        cache.getBool(key: CacheKey.onBoardingViewed) ?? false;

    if (accessToken != null && accessToken.isNotEmpty) {
      if (JwtDecoder.isExpired(accessToken)) {
        if (refreshToken != null && refreshToken.isNotEmpty) {
          final refreshed = await _tryRefreshToken(authService, cache, refreshToken);
          if (refreshed) {
            destinationRoute = AppRoutes.kHomeView;
          } else {
            await _clearSession(cache);
            destinationRoute = AppRoutes.kEmailView;
          }
        } else {
          await _clearSession(cache);
          destinationRoute = AppRoutes.kEmailView;
        }
      } else {
        destinationRoute = AppRoutes.kHomeView;
      }
    } else if (onboardingSeen) {
      destinationRoute = AppRoutes.kEmailView;
    } else {
      showButtons = true;
    }

    notifyListeners();
  }

  Future<bool> _tryRefreshToken(
    AuthService authService,
    CacheHelper cache,
    String refreshToken,
  ) async {
    try {
      final response = await authService.refreshToken(refreshToken);
      final data = response.data;
      if (data is Map) {
        final newAccess = (data['accessToken'] ?? data['access_token'])?.toString();
        final newRefresh = (data['refreshToken'] ?? data['refresh_token'])?.toString();

        if (newAccess != null && newAccess.isNotEmpty) {
          await cache.saveData(key: CacheKey.accessToken, value: newAccess);
          await cache.saveSecureData(key: CacheKey.accessToken, value: newAccess);
          if (newRefresh != null && newRefresh.isNotEmpty) {
            await cache.saveData(key: CacheKey.refreshToken, value: newRefresh);
            await cache.saveSecureData(key: CacheKey.refreshToken, value: newRefresh);
          }
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> _clearSession(CacheHelper cache) async {
    await cache.deleteData(key: CacheKey.accessToken);
    await cache.deleteData(key: CacheKey.refreshToken);
    await cache.deleteAllSecureData();
  }

  void disposeController() {
    _timer?.cancel();
  }
}