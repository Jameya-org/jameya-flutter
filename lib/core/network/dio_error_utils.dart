import 'package:dio/dio.dart';

/// Safely reads the `message` field from a Dio error response body.
///
/// The error body is not guaranteed to be a Map (it can be a String, List,
/// etc.), so direct `data['message']` access would crash inside the catch
/// block. Falls back to the [DioException.message] or [fallback].
String dioErrorMessage(DioException e, {String fallback = 'حدث خطأ'}) {
  final data = e.response?.data;
  if (data is Map) {
    final message = data['message'];
    if (message != null && message.toString().trim().isNotEmpty) {
      return message.toString();
    }
  }
  return e.message ?? fallback;
}
