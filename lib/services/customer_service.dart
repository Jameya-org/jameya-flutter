import 'package:jameya_user/core/api_client.dart';

class CustomerService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiClient.dio.get('/customers/profile');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Unexpected profile response format');
  }

  Future<void> updateProfile({
    required String legalName,
    required String mobileNumber,
    required String nationalIdNumber,
    required String dateOfBirthIso,
    required String governorate,
    required String city,
    required String streetAddress,
  }) async {
    await _apiClient.dio.post(
      '/customers/profile',
      data: {
        'legalName': legalName,
        'mobileNumber': mobileNumber,
        'nationalIdNumber': nationalIdNumber,
        'dateOfBirth': dateOfBirthIso,
        'address': {
          'governorate': governorate,
          'city': city,
          'streetAddress': streetAddress,
        },
      },
    );
  }
}
