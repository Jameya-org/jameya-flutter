import 'package:dio/dio.dart';

import '../models/home_dashboard_model.dart';

class HomeService {
  final Dio dio;

  HomeService(this.dio);

  Future<Map<String, dynamic>> getHomeDashboard() async {
    final response = await dio.get('/customer/home');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected home dashboard response format');
  }

  Future<List<dynamic>> getMyCircles() async {
    final response = await dio.get('/customer/my-circles');
    final data = response.data;
    if (data is List) return data;
    throw StateError('Unexpected my-circles response format');
  }

  Future<List<dynamic>> getAvailableCircles() async {
    final response = await dio.get('/customer/circles');
    final data = response.data;
    if (data is List) return data;
    throw StateError('Unexpected circles response format');
  }

  Future<Map<String, dynamic>> getCircleDetail(int id) async {
    final response = await dio.get('/customer/circles/$id');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected circle detail response format');
  }

  Future<Map<String, dynamic>> getCirclePositions(int id) async {
    final response = await dio.get('/customer/circles/$id/positions');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected circle positions response format');
  }

  Future<void> joinIntent(int id) async {
    await dio.post('/customer/circles/$id/join-intent');
  }
}
