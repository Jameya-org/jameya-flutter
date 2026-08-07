import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../cache/cache_helper.dart';
import '../cache/cache_keys.dart';

class _QueuedRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _QueuedRequest(this.options, this.handler);
}

/// [AppInterceptor]:
/// 1. Automatically attaches the JWT access token to every request.
/// 2. Intercepts 401 Unauthorized errors, queues pending requests, and automatically refreshes access token.
/// 3. Retries original and queued requests sequentially after a successful refresh.
/// 4. Logs every request, response, and error in a structured, readable format.
class AppInterceptor extends Interceptor {
  final CacheHelper _cacheHelper;
  final Dio _refreshDio;

  bool _isRefreshing = false;
  final List<_QueuedRequest> _failedQueue = [];

  AppInterceptor(this._cacheHelper)
      : _refreshDio = Dio(
          BaseOptions(
            baseUrl: 'https://jameya-backend.onrender.com',
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {'Content-Type': 'application/json'},
          ),
        );

  Future<String?> _getAccessToken() async {
    String? token = await _cacheHelper.getSecureData(key: CacheKeys.accessToken);
    token ??= _cacheHelper.getString(key: CacheKeys.accessToken);
    return token;
  }

  Future<String?> _getRefreshToken() async {
    String? token = await _cacheHelper.getSecureData(key: CacheKeys.refreshToken);
    token ??= _cacheHelper.getString(key: CacheKeys.refreshToken);
    return token;
  }

  Future<void> _saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _cacheHelper.saveData(key: CacheKeys.accessToken, value: accessToken);
    await _cacheHelper.saveSecureData(key: CacheKeys.accessToken, value: accessToken);

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _cacheHelper.saveData(key: CacheKeys.refreshToken, value: refreshToken);
      await _cacheHelper.saveSecureData(key: CacheKeys.refreshToken, value: refreshToken);
    }
  }

  /// Clears all authentication AND cached profile / KYC data so no stale
  /// information remains after a session is invalidated.
  Future<void> _clearSession() async {
    // Auth tokens
    await _cacheHelper.deleteData(key: CacheKeys.accessToken);
    await _cacheHelper.deleteData(key: CacheKeys.refreshToken);
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
    final token = await _getAccessToken();
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
      // If already refreshing, queue this request and wait.
      if (_isRefreshing) {
        _failedQueue.add(_QueuedRequest(err.requestOptions, handler));
        return;
      }

      // Guard: if no refresh token exists at all, clear session immediately.
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        await _clearSession();
        _rejectQueue(err);
        handler.next(err);
        return;
      }

      _isRefreshing = true;

      final newAccessToken = await _attemptRefresh(refreshToken);
      _isRefreshing = false;

      if (newAccessToken != null) {
        // Update token on the original failing request.
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        try {
          // Retry the original request first.
          final retriedResponse = await _refreshDio.fetch(err.requestOptions);
          // Then sequentially retry all queued requests.
          await _processQueue(newAccessToken);
          handler.resolve(retriedResponse);
        } on DioException catch (retryErr) {
          await _processQueue(newAccessToken);
          handler.reject(retryErr);
        }
      } else {
        // Refresh failed — clear session and reject everything.
        await _clearSession();
        _rejectQueue(err);
        handler.next(err);
      }

      return;
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
        data: {'refreshToken': refreshToken},
      );

      final data = response.data;
      if (data is Map) {
        final newAccess = (data['accessToken'] ?? data['access_token'])?.toString();
        final newRefresh = (data['refreshToken'] ?? data['refresh_token'])?.toString();

        if (newAccess != null && newAccess.isNotEmpty) {
          await _saveTokens(
            accessToken: newAccess,
            refreshToken: newRefresh,
          );
          return newAccess;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Sequentially retries all queued requests using the new [newToken].
  ///
  /// Sequential (not parallel) to avoid thundering-herd after refresh and to
  /// ensure each queued request gets the correct new token.
  Future<void> _processQueue(String newToken) async {
    final snapshot = List<_QueuedRequest>.from(_failedQueue);
    _failedQueue.clear();

    for (final item in snapshot) {
      item.options.headers['Authorization'] = 'Bearer $newToken';
      try {
        final res = await _refreshDio.fetch(item.options);
        item.handler.resolve(res);
      } on DioException catch (e) {
        item.handler.reject(e);
      }
    }
  }

  void _rejectQueue(DioException err) {
    final snapshot = List<_QueuedRequest>.from(_failedQueue);
    _failedQueue.clear();
    for (final item in snapshot) {
      item.handler.reject(err);
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
