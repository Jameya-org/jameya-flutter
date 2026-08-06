import 'dart:io';
import 'package:dio/dio.dart';

class KycService {
  final Dio dio;

  KycService(this.dio);

  Future<Map<String, dynamic>> getKycStatus() async {
    final response = await dio.get('/customers/kyc-status');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected KYC status response');
  }

  Future<void> uploadDocument({
    required File file,
    required String documentType,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
      'documentType': documentType,
    });
    await dio.post('/customers/documents', data: formData);
  }

  Future<void> submitForReview() async {
    await dio.post('/customers/kyc/submit');
  }
}
