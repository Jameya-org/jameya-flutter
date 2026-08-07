import 'package:dio/dio.dart';

class KycService {
  final Dio dio;

  KycService(this.dio);

  /// GET /customers/kyc-status
  ///
  /// Returns the full KYC status object which includes:
  /// - legalName
  /// - kycStatus
  /// - identityProfile
  /// - documents
  /// - latestEligibility
  Future<Map<String, dynamic>> getKycStatus() async {
    final response = await dio.get('/customers/kyc-status');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected KYC status response format');
  }

  /// POST /customers/documents — STEP 2 of the two-step document upload flow.
  ///
  /// The [encryptedObjectRef] MUST be the [secureUrl] returned from
  /// POST /storage/upload (Step 1). The caller is responsible for providing
  /// it — never pass a local file path here.
  ///
  /// Body (JSON):
  /// ```json
  /// {
  ///   "docType": "...",
  ///   "encryptedObjectRef": "<secureUrl from storage upload>",
  ///   "issueDate": "...",      // optional — omitted if null
  ///   "expiryDate": "..."      // optional — omitted if null
  /// }
  /// ```
  ///
  /// Throws [DioException] on failure so the caller can surface the exact
  /// backend message to the UI.
  Future<void> uploadDocument({
    required String docType,
    required String encryptedObjectRef,
    String? issueDate,
    String? expiryDate,
  }) async {
    final body = <String, dynamic>{
      'docType': docType,
      'encryptedObjectRef': encryptedObjectRef,
    };

    // Only include date fields when they have meaningful values.
    if (issueDate != null && issueDate.isNotEmpty) {
      body['issueDate'] = issueDate;
    }
    if (expiryDate != null && expiryDate.isNotEmpty) {
      body['expiryDate'] = expiryDate;
    }

    try {
      await dio.post('/customers/documents', data: body);
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
