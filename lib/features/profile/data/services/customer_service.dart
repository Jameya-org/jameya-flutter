import 'package:dio/dio.dart';

class CustomerService {
  final Dio dio;

  CustomerService(this.dio);

  /// GET /customers/profile
  Future<Map<String, dynamic>> getProfile() async {
    final response = await dio.get('/customers/profile');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected profile response format');
  }

  /// POST /customers/profile
  ///
  /// Creates or updates the customer's identity profile.
  ///
  /// Throws [DioException] on failure so callers can surface the backend
  /// validation message (e.g. 400 errors) directly to the UI.
  Future<void> updateProfile({
    required String legalName,
    required String mobileNumber,
    required String nationalIdNumber,
    required String dateOfBirthIso,
    required String governorate,
    required String city,
    required String streetAddress,
  }) async {
    try {
      await dio.post(
        '/customers/profile',
        data: {
          'legalName': legalName,
          'dateOfBirth': dateOfBirthIso,
          'nationalIdNumber': nationalIdNumber,
          'address': {
            'governorate': governorate,
            'city': city,
            'streetAddress': streetAddress,
          },
          'mobileNumber': mobileNumber,
        },
      );
    } on DioException {
      rethrow;
    }
  }
}
