import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../cache/cache_helper.dart';
import '../cache/cache_keys.dart';
import '../utils/token_utils.dart';

/// [AppInterceptor]:
/// 1. Automatically attaches the JWT access token to every request.
/// 2. Intercepts 401 Unauthorized errors, locks concurrent requests via [Completer],
///    and automatically refreshes the access token using the refresh token.
/// 3. Retries original and concurrent requests sequentially after a successful refresh.
/// 4. Logs every request, response, and error in a structured, readable format.
class AppInterceptor extends Interceptor {
  final CacheHelper _cacheHelper;
  final Dio _refreshDio;

  Completer<String?>? _refreshCompleter;

  AppInterceptor(this._cacheHelper)
      : _refreshDio = Dio(
          BaseOptions(
            baseUrl: 'https://jameya-backend.onrender.com',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Content-Type': 'application/json'},
          ),
        );

  /// Clears all authentication AND cached profile / KYC data so no stale
  /// information remains after a session is invalidated.
  Future<void> _clearSession() async {
    await TokenUtils.clearTokens(_cacheHelper);
    await _cacheHelper.deleteAllSecureData();

    // Cached profile fields
    await _cacheHelper.deleteData(key: CacheKeys.email);
    await _cacheHelper.deleteData(key: CacheKeys.legalName);
    await _cacheHelper.deleteData(key: CacheKeys.phone);
  }

  // ─────────────────────────────────────────────
  // Request
  // ─────────────────────────────────────────────

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenUtils.getAccessToken(_cacheHelper);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    final buffer = StringBuffer();
    buffer.writeln('┌─────────────────────────────────────────────');
    buffer.writeln('│ 📤 REQUEST');
    buffer.writeln('│ Method  : ${options.method}');
    buffer.writeln('│ URL     : ${options.uri}');

    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('│ Query   : ${options.queryParameters}');
    }

    if (options.headers.isNotEmpty) {
      buffer.writeln('│ Headers :');
      options.headers.forEach(
        (k, v) => buffer.writeln('│   $k: $v'),
      );
    }

    if (options.data != null) {
      buffer.writeln('│ Body    : ${options.data}');
    }

    buffer.writeln('└─────────────────────────────────────────────');
    debugPrint(buffer.toString());

    handler.next(options);
  }

  // ─────────────────────────────────────────────
  // Response
  // ─────────────────────────────────────────────

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final buffer = StringBuffer();
    buffer.writeln('┌─────────────────────────────────────────────');
    buffer.writeln('│ ✅ RESPONSE');
    buffer.writeln('│ URL     : ${response.requestOptions.uri}');
    buffer.writeln('│ Status  : ${response.statusCode}');

    if (response.headers.map.isNotEmpty) {
      buffer.writeln('│ Headers :');
      response.headers.map.forEach(
        (k, v) => buffer.writeln('│   $k: ${v.join(', ')}'),
      );
    }

    buffer.writeln('│ Body    : ${_formatBody(response.data)}');
    buffer.writeln('└─────────────────────────────────────────────');
    debugPrint(buffer.toString());

    handler.next(response);
  }

  // ─────────────────────────────────────────────
  // Error
  // ─────────────────────────────────────────────

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final buffer = StringBuffer();
    buffer.writeln('┌─────────────────────────────────────────────');
    buffer.writeln('│ ❌ ERROR');
    buffer.writeln('│ URL     : ${err.requestOptions.uri}');
    buffer.writeln('│ Type    : ${err.type.name}');

    if (err.response != null) {
      buffer.writeln('│ Status  : ${err.response!.statusCode}');
      buffer.writeln('│ Body    : ${_formatBody(err.response!.data)}');
    }

    buffer.writeln('│ Message : ${err.message}');
    buffer.writeln('└─────────────────────────────────────────────');
    debugPrint(buffer.toString());

    // ── Check for 401 Unauthorized token refresh logic ──
    final isUnauthorized = err.response?.statusCode == 401;
    final isAuthEndpoint = err.requestOptions.path.contains('/auth/');

    if (isUnauthorized && !isAuthEndpoint) {
      // 1) If a token refresh is already in progress, await its completer.
      if (_refreshCompleter != null) {
        final newAccessToken = await _refreshCompleter!.future;
        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          try {
            err.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';
            final retriedResponse = await _refreshDio.fetch(err.requestOptions);
            return handler.resolve(retriedResponse);
          } on DioException catch (retryErr) {
            return handler.reject(retryErr);
          }
        } else {
          return handler.next(err);
        }
      }

      // 2) Synchronously initialize completer to prevent parallel race conditions.
      final completer = Completer<String?>();
      _refreshCompleter = completer;

      try {
        final refreshToken = await TokenUtils.getRefreshToken(_cacheHelper);
        if (refreshToken == null || refreshToken.isEmpty) {
          await _clearSession();
          completer.complete(null);
          _refreshCompleter = null;
          return handler.next(err);
        }

        final newAccessToken = await _attemptRefresh(refreshToken);
        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          completer.complete(newAccessToken);
          _refreshCompleter = null;

          err.requestOptions.headers['Authorization'] =
              'Bearer $newAccessToken';
          final retriedResponse = await _refreshDio.fetch(err.requestOptions);
          return handler.resolve(retriedResponse);
        } else {
          await _clearSession();
          completer.complete(null);
          _refreshCompleter = null;
          return handler.next(err);
        }
      } catch (refreshErr) {
        await _clearSession();
        completer.complete(null);
        _refreshCompleter = null;
        return handler.next(err);
      }
    }

    handler.next(err);
  }

  /// Attempts to refresh the access token using [refreshToken].
  ///
  /// Returns the new access token string on success, or `null` on failure.
  Future<String?> _attemptRefresh(String refreshToken) async {
    try {
      final response = await _refreshDio.post(
        '/auth/refresh',
        data: {
          'refreshToken': refreshToken,
          'refresh_token': refreshToken,
        },
      );

      final data = response.data;
      final newAccess = TokenUtils.extractAccessToken(data);
      final newRefresh = TokenUtils.extractRefreshToken(data);

      if (newAccess != null && newAccess.isNotEmpty) {
        await TokenUtils.saveTokens(
          _cacheHelper,
          accessToken: newAccess,
          refreshToken: newRefresh ?? refreshToken,
        );
        return newAccess;
      }
      return null;
    } catch (e) {
      debugPrint('AppInterceptor: Token refresh endpoint error: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────

  String _formatBody(dynamic data) {
    if (data == null) return '(empty)';
    if (data is String) return data.isEmpty ? '(empty)' : data;
    return data.toString();
  }
}
