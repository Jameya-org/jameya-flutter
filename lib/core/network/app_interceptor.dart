import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../cache/cache_helper.dart';
import '../cache/cache_key.dart';

class _QueuedRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;

  _QueuedRequest(this.options, this.handler);
}

/// [AppInterceptor]:
/// 1. Automatically attaches the JWT access token to every request.
/// 2. Intercepts 401 Unauthorized errors, queues pending requests, and automatically refreshes access token.
/// 3. Retries original and queued requests seamlessly.
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
    String? token = await _cacheHelper.getSecureData(key: CacheKey.accessToken);
    token ??= _cacheHelper.getString(key: CacheKey.accessToken);
    return token;
  }

  Future<String?> _getRefreshToken() async {
    String? token = await _cacheHelper.getSecureData(key: CacheKey.refreshToken);
    token ??= _cacheHelper.getString(key: CacheKey.refreshToken);
    return token;
  }

  Future<void> _saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _cacheHelper.saveData(key: CacheKey.accessToken, value: accessToken);
    await _cacheHelper.saveSecureData(key: CacheKey.accessToken, value: accessToken);

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _cacheHelper.saveData(key: CacheKey.refreshToken, value: refreshToken);
      await _cacheHelper.saveSecureData(key: CacheKey.refreshToken, value: refreshToken);
    }
  }

  Future<void> _clearSession() async {
    await _cacheHelper.deleteData(key: CacheKey.accessToken);
    await _cacheHelper.deleteData(key: CacheKey.refreshToken);
    await _cacheHelper.deleteAllSecureData();
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
      if (_isRefreshing) {
        // Queue pending request until refresh finishes
        _failedQueue.add(_QueuedRequest(err.requestOptions, handler));
        return;
      }

      _isRefreshing = true;

      final success = await _attemptRefresh();
      _isRefreshing = false;

      if (success) {
        final newToken = await _getAccessToken();
        if (newToken != null && newToken.isNotEmpty) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        }

        try {
          final retriedResponse = await _refreshDio.fetch(err.requestOptions);
          handler.resolve(retriedResponse);
        } on DioException catch (retryErr) {
          handler.reject(retryErr);
        }

        // Retry all queued requests
        _processQueue(newToken);
        return;
      } else {
        await _clearSession();
        _rejectQueue(err);
        handler.next(err);
        return;
      }
    }

    handler.next(err);
  }

  Future<bool> _attemptRefresh() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

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
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  void _processQueue(String? newToken) async {
    for (final item in _failedQueue) {
      if (newToken != null && newToken.isNotEmpty) {
        item.options.headers['Authorization'] = 'Bearer $newToken';
      }
      try {
        final res = await _refreshDio.fetch(item.options);
        item.handler.resolve(res);
      } on DioException catch (e) {
        item.handler.reject(e);
      }
    }
    _failedQueue.clear();
  }

  void _rejectQueue(DioException err) {
    for (final item in _failedQueue) {
      item.handler.reject(err);
    }
    _failedQueue.clear();
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
