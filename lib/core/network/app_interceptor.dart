import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../cache/cache_helper.dart';
import '../cache/cache_key.dart';

/// A single [Interceptor] that:
/// 1. Automatically attaches the JWT access token to every request.
/// 2. Logs every request, response, and error in a structured, readable format.
class AppInterceptor extends Interceptor {
  final CacheHelper _cacheHelper;

  AppInterceptor(this._cacheHelper);

  // ─────────────────────────────────────────────
  // Request
  // ─────────────────────────────────────────────

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ── Auth injection ──────────────────────────
    final token = _cacheHelper.getString(key: CacheKey.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // ── Logging ─────────────────────────────────
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
  void onError(DioException err, ErrorInterceptorHandler handler) {
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

    handler.next(err);
  }

  // ─────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────

  /// Converts a response body to a readable string without truncation.
  String _formatBody(dynamic data) {
    if (data == null) return '(empty)';
    if (data is String) return data.isEmpty ? '(empty)' : data;
    return data.toString();
  }
}
