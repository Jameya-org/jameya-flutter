import 'package:dio/dio.dart';

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
  /// Real response: { data: [...] }
  Future<List<dynamic>> getMyCircles() async {
    final response = await dio.get('/customer/my-circles');
    final data = response.data;
    if (data is Map) {
      final circles = data['data'] ?? data['circles'];
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

    if (data is Map) {
      final list = data['data'];
      if (list is List) return list;
      return [];
    }

    if (data is List) {
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

  // ── Join Circle Flow ────────────────────────────────────────

  /// POST /customer/circles/{id}/join-intent
  /// 200 → { canJoin, circleId, eligible, ... }
  /// 422 → { reason, missingSteps }  (DioException thrown by Dio)
  Future<Map<String, dynamic>> checkJoinIntent(String id) async {
    final response = await dio.post('/customer/circles/$id/join-intent');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected join-intent response format: ${data.runtimeType}');
  }

  /// POST /customer/circles/{id}/join
  /// 201 → { membershipId, reservationId, reservationExpiresAt, status, contract }
  /// 409 → { reason: "position_taken" }
  /// 422 → { reason: "eligibility_incomplete", missingSteps }
  Future<Map<String, dynamic>> joinCircle(
    String id,
    int position, {
    String? paymentMethodId,
    String? cardToken,
  }) async {
    final body = <String, dynamic>{'payoutPosition': position};
    if (paymentMethodId != null) body['paymentMethodId'] = paymentMethodId;
    if (cardToken != null) body['cardToken'] = cardToken;

    final response = await dio.post('/customer/circles/$id/join', data: body);
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected join response format: ${data.runtimeType}');
  }

  /// POST /customer/join/{membershipId}/contract/accept
  /// 200 → { success, membershipId, otpSent, expiresIn, message }
  /// 410 → { reason: "reservation_expired" }
  Future<Map<String, dynamic>> acceptContract(
    String membershipId, {
    required bool agreedToTerms,
    required bool agreedToInstallmentSchedule,
    required bool agreedToLateFees,
  }) async {
    final response = await dio.post(
      '/customer/join/$membershipId/contract/accept',
      data: {
        'agreedToTerms': agreedToTerms,
        'agreedToInstallmentSchedule': agreedToInstallmentSchedule,
        'agreedToLateFees': agreedToLateFees,
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected acceptContract response format: ${data.runtimeType}');
  }

  /// POST /customer/join/{membershipId}/contract/verify-otp
  /// 200 → { success, membershipId, status, joinedAt, message }
  /// 4xx → { reason: "invalid_otp" | "otp_expired", message }
  Future<Map<String, dynamic>> verifyJoinOtp(
    String membershipId,
    String otp,
  ) async {
    final response = await dio.post(
      '/customer/join/$membershipId/contract/verify-otp',
      data: {'otp': otp},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected verifyOtp response format: ${data.runtimeType}');
  }

  /// GET /customer/contracts/{membershipId}/download
  /// Returns raw PDF bytes — do NOT parse as JSON.
  Future<Response<dynamic>> downloadContract(String membershipId) async {
    return await dio.get(
      '/customer/contracts/$membershipId/download',
      options: Options(responseType: ResponseType.bytes),
    );
  }
}
