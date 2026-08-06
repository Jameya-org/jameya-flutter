import '../models/home_dashboard_model.dart';
import '../models/join_circle_models.dart';
import '../services/home_service.dart';

class HomeRepo {
  final HomeService homeService;

  HomeRepo(this.homeService);

  /// GET /customer/home → HomeEligibilityModel
  Future<HomeEligibilityModel> getHomeDashboard() async {
    final data = await homeService.getHomeDashboard();
    return HomeEligibilityModel.fromJson(data);
  }

  /// GET /customer/my-circles → List of MyCircleModel
  /// Uses the new response shape: { data: [...] }
  Future<List<MyCircleModel>> getMyCircles() async {
    final list = await homeService.getMyCircles();
    return list.map((e) {
      final map = e is Map<String, dynamic>
          ? e
          : Map<String, dynamic>.from(e as Map);
      return MyCircleModel.fromJson(map);
    }).toList();
  }

  /// GET /customer/circles → reads from response.data array
  Future<List<CircleSummaryModel>> getAvailableCircles() async {
    final list = await homeService.getAvailableCircles();

    return list.map((e) {
      final map = e is Map<String, dynamic>
          ? e
          : Map<String, dynamic>.from(e as Map);
      return CircleSummaryModel.fromJson(map);
    }).toList();
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

  // ── Join Circle Flow ────────────────────────────────────────

  /// POST /customer/circles/{id}/join-intent
  Future<JoinIntentResponseModel> checkJoinIntent(String id) async {
    final data = await homeService.checkJoinIntent(id);
    return JoinIntentResponseModel.fromJson(data);
  }

  /// POST /customer/circles/{id}/join
  Future<JoinReservationModel> joinCircle(
    String id,
    int position, {
    String? paymentMethodId,
    String? cardToken,
  }) async {
    final data = await homeService.joinCircle(
      id,
      position,
      paymentMethodId: paymentMethodId,
      cardToken: cardToken,
    );
    return JoinReservationModel.fromJson(data);
  }

  /// POST /customer/join/{membershipId}/contract/accept
  Future<AcceptContractResponseModel> acceptContract(
    String membershipId, {
    required bool agreedToTerms,
    required bool agreedToInstallmentSchedule,
    required bool agreedToLateFees,
  }) async {
    final data = await homeService.acceptContract(
      membershipId,
      agreedToTerms: agreedToTerms,
      agreedToInstallmentSchedule: agreedToInstallmentSchedule,
      agreedToLateFees: agreedToLateFees,
    );
    return AcceptContractResponseModel.fromJson(data);
  }

  /// POST /customer/join/{membershipId}/contract/verify-otp
  Future<VerifyOtpResponseModel> verifyJoinOtp(
    String membershipId,
    String otp,
  ) async {
    final data = await homeService.verifyJoinOtp(membershipId, otp);
    return VerifyOtpResponseModel.fromJson(data);
  }

  /// GET /customer/contracts/{membershipId}/download
  /// Returns raw bytes — caller handles opening the PDF.
  Future<List<int>> downloadContract(String membershipId) async {
    final response = await homeService.downloadContract(membershipId);
    final bytes = response.data;
    if (bytes is List<int>) return bytes;
    if (bytes is List) return bytes.cast<int>();
    throw StateError('Unexpected contract download response type: ${bytes.runtimeType}');
  }
}
