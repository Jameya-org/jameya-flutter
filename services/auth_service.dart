import 'package:jameya_user/core/api_client.dart';
import 'package:jameya_user/core/token_storage.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<void> requestOtp(String email) async {
    final response = await _apiClient.dio.post(
      '/auth/request-otp',
      data: {'email': email},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to request OTP');
    }
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    final response = await _apiClient.dio.post(
      '/auth/verify-otp',
      data: {'email': email, 'otp': otp},
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      if (accessToken != null && refreshToken != null) {
        await TokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        return;
      }
    }

    throw Exception('Invalid verification response');
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
    } finally {
      await TokenStorage.clear();
    }
  }
}
