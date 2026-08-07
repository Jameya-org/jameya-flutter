import 'package:dio/dio.dart';

class KycService {
  final Dio dio;

  KycService(this.dio);

  /// GET /customers/kyc-status
  Future<Map<String, dynamic>> getKycStatus() async {
    final response = await dio.get('/customers/kyc-status');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected KYC status response format');
  }

  /// POST /customers/documents
  ///
  /// Body (JSON):
  /// ```json
  /// {
  ///   "docType": "...",
  ///   "encryptedObjectRef": "...",
  ///   "issueDate": "...",
  ///   "expiryDate": "..."
  /// }
  /// ```
  ///
  /// Throws a [DioException] on failure so the caller can surface the
  /// backend message (e.g. validation errors) directly to the UI.
  Future<void> uploadDocument({
    required String docType,
    required String encryptedObjectRef,
    required String issueDate,
    required String expiryDate,
  }) async {
    try {
      await dio.post(
        '/customers/documents',
        data: {
          'docType': docType,
          'encryptedObjectRef': encryptedObjectRef,
          'issueDate': issueDate,
          'expiryDate': expiryDate,
        },
      );
    } on DioException {
      rethrow;
    }
  }

  /// POST /customers/kyc/submit
  ///
  /// No request body. Throws [DioException] so the caller can extract and
  /// display the exact backend error message (e.g. 400 with proof-of-income
  /// missing).
  Future<void> submitForReview() async {
    try {
      await dio.post('/customers/kyc/submit');
    } on DioException {
      rethrow;
    }
  }
}
