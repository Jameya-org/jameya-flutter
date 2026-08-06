import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HomeService {
  final Dio dio;

  HomeService(this.dio);

  /// GET /customer/home
  /// Real response: { eligible, reason, missingSteps }
  Future<Map<String, dynamic>> getHomeDashboard() async {
    final response = await dio.get('/customer/home');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected home dashboard response format: ${data.runtimeType}');
  }

  /// GET /customer/my-circles
  /// Real response: { circles: [...] } or { data: [...] }
  Future<List<dynamic>> getMyCircles() async {
    final response = await dio.get('/customer/my-circles');
    final data = response.data;
    if (data is Map) {
      final circles = data['circles'] ?? data['data'];
      if (circles is List) return circles;
      return [];
    }
    if (data is List) return data;
    throw StateError('Unexpected my-circles response format: ${data.runtimeType}');
  }

  /// GET /customer/circles
  /// Real response: { data: [...], meta: {...} }
  Future<List<dynamic>> getAvailableCircles() async {
    final response = await dio.get('/customer/circles');
    final data = response.data;
    debugPrint('[TRACE 1] Raw Dio response type: ${data.runtimeType}');

    if (data is Map) {
      final list = data['data'];
      final meta = data['meta'];
      debugPrint('[TRACE 2] response.data["data"] length: ${list is List ? list.length : 0}');
      debugPrint('[TRACE 3] response.data["meta"]: $meta');
      if (list is List) return list;
      return [];
    }

    if (data is List) {
      debugPrint('[TRACE 2] response.data (List) length: ${data.length}');
      return data;
    }

    throw StateError('Unexpected circles response format: ${data.runtimeType}');
  }

  /// GET /customer/circles/{id}
  Future<Map<String, dynamic>> getCircleDetail(String id) async {
    final response = await dio.get('/customer/circles/$id');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected circle detail response format: ${data.runtimeType}');
  }

  /// GET /customer/circles/{id}/positions
  Future<Map<String, dynamic>> getCirclePositions(String id) async {
    final response = await dio.get('/customer/circles/$id/positions');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected circle positions response format: ${data.runtimeType}');
  }

  Future<void> joinIntent(String id) async {
    await dio.post('/customer/circles/$id/join-intent');
  }
}
