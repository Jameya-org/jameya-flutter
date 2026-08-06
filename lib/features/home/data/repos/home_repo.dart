import '../models/home_dashboard_model.dart';
import '../services/home_service.dart';

class HomeRepo {
  final HomeService homeService;

  HomeRepo(this.homeService);

  Future<HomeDashboardModel> getHomeDashboard() async {
    final data = await homeService.getHomeDashboard();
    return HomeDashboardModel.fromJson(data);
  }

  Future<List<CircleSummaryModel>> getMyCircles() async {
    final data = await homeService.getMyCircles();
    return data
        .map((e) => CircleSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CircleSummaryModel>> getAvailableCircles() async {
    final data = await homeService.getAvailableCircles();
    return data
        .map((e) => CircleSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
