import 'dart:io';
import 'package:dio/dio.dart';
import 'package:jameya_user/core/api_client.dart';

class KycService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getKycStatus() async {
    final response = await _apiClient.dio.get('/customers/kyc-status');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected KYC status response');
  }

  /// رفع مستند (هوية وطنية أو إثبات مرتب)
  /// documentType متوقع يكون مثلاً: 'NATIONAL_ID' أو 'INCOME_PROOF'
  Future<void> uploadDocument({
    required File file,
    required String documentType,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'documentType': documentType,
    });
    await _apiClient.dio.post('/customers/documents', data: formData);
  }

  Future<void> submitForReview() async {
    await _apiClient.dio.post('/customers/kyc/submit');
  }
}
