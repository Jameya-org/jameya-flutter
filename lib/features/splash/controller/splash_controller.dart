import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/cache/cache_keys.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/jwt_decoder.dart';
import '../../../../core/utils/token_utils.dart';
import '../../auth/data/services/auth_service.dart';

enum _RefreshOutcome { success, authFailure, transientFailure }

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

    final accessToken = await TokenUtils.getAccessToken(cache);
    final refreshToken = await TokenUtils.getRefreshToken(cache);

    final onboardingSeen =
        cache.getBool(key: CacheKeys.onBoardingViewed) ?? false;

    if (accessToken != null && accessToken.isNotEmpty) {
      if (JwtDecoder.isExpired(accessToken)) {
        if (refreshToken != null && refreshToken.isNotEmpty) {
          final outcome = await _tryRefreshToken(authService, cache, refreshToken);
          switch (outcome) {
            case _RefreshOutcome.success:
              destinationRoute = AppRoutes.kHomeView;
            case _RefreshOutcome.authFailure:
              // Refresh token is invalid/revoked — session must be cleared.
              await _clearSession(cache);
              destinationRoute = AppRoutes.kEmailView;
            case _RefreshOutcome.transientFailure:
              // Network/timeout. Keep the session — the request interceptor
              // will retry the refresh on the next 401 instead of logging the
              // user out for a temporary connectivity problem.
              destinationRoute = AppRoutes.kHomeView;
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

  Future<_RefreshOutcome> _tryRefreshToken(
    AuthService authService,
    CacheHelper cache,
    String refreshToken,
  ) async {
    try {
      final response = await authService.refreshToken(refreshToken);
      final data = response.data;
      final newAccess = TokenUtils.extractAccessToken(data);
      final newRefresh = TokenUtils.extractRefreshToken(data);

      if (newAccess != null && newAccess.isNotEmpty) {
        await TokenUtils.saveTokens(
          cache,
          accessToken: newAccess,
          refreshToken: newRefresh ?? refreshToken,
        );
        return _RefreshOutcome.success;
      }
      // Server responded, but the payload didn't contain a usable token.
      return _RefreshOutcome.authFailure;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode != null) {
        // The server answered with an HTTP error — token is invalid/revoked.
        return _RefreshOutcome.authFailure;
      }
      // No HTTP response (connection refused, timeout, DNS, ...) — transient.
      return _RefreshOutcome.transientFailure;
    } catch (_) {
      return _RefreshOutcome.transientFailure;
    }
  }

  Future<void> _clearSession(CacheHelper cache) async {
    await TokenUtils.clearTokens(cache);
    await cache.deleteAllSecureData();
  }

  void disposeController() {
    _timer?.cancel();
  }
}
