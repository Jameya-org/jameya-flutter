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

  /// GET /customer/my-circles → reads from response.circles
  Future<List<CircleSummaryModel>> getMyCircles() async {
    final list = await homeService.getMyCircles();
    return list
        .map((e) => CircleSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /customer/circles → reads from response.data
  Future<List<CircleSummaryModel>> getAvailableCircles() async {
    final list = await homeService.getAvailableCircles();
    return list
        .map((e) => CircleSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
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
