import 'package:flutter/foundation.dart';

import '../models/home_dashboard_model.dart';
import '../services/home_service.dart';

class HomeRepo {
  final HomeService homeService;

  HomeRepo(this.homeService);

  /// GET /customer/home → HomeEligibilityModel
  Future<HomeEligibilityModel> getHomeDashboard() async {
    final data = await homeService.getHomeDashboard();
    return HomeEligibilityModel.fromJson(data);
  }

  /// GET /customer/my-circles → reads from response.circles or response.data
  Future<List<CircleSummaryModel>> getMyCircles() async {
    final list = await homeService.getMyCircles();
    return list.map((e) {
      if (e is Map<String, dynamic>) {
        return CircleSummaryModel.fromJson(e);
      } else if (e is Map) {
        return CircleSummaryModel.fromJson(Map<String, dynamic>.from(e));
      }
      throw FormatException('Element in my circles list is not a Map: $e');
    }).toList();
  }

  /// GET /customer/circles → reads from response.data array
  Future<List<CircleSummaryModel>> getAvailableCircles() async {
    final list = await homeService.getAvailableCircles();
    debugPrint('[TRACE 4] DTO parsing starting for ${list.length} raw items');

    final models = list.map((e) {
      final map = e is Map<String, dynamic>
          ? e
          : Map<String, dynamic>.from(e as Map);
      final model = CircleSummaryModel.fromJson(map);
      debugPrint('[TRACE 5] Parsed CircleModel: id=${model.id}, title="${model.title}", status="${model.status}"');
      return model;
    }).toList();

    debugPrint('[TRACE 6] Repository output length: ${models.length}');
    return models;
  }

  /// GET /customer/circles/{id}
  Future<CircleDetailModel> getCircleDetail(String id) async {
    final data = await homeService.getCircleDetail(id);
    return CircleDetailModel.fromJson(data);
  }

  /// GET /customer/circles/{id}/positions
  Future<CirclePositionsModel> getCirclePositions(String id) async {
    final data = await homeService.getCirclePositions(id);
    return CirclePositionsModel.fromJson(data);
  }
}
