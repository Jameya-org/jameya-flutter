import 'package:dio/dio.dart';

import '../models/request_otp_model.dart';
import '../models/verify_otp_model.dart';

class AuthService {
  AuthService(this.dio);
  final Dio dio;

  Future<Response> requestOtp(RequestOtpModel model) async {
    return dio.post('/auth/request-otp', data: model.toJson());
  }

  Future<Response> verifyOtp(VerifyOtpModel model) async {
    return dio.post('/auth/verify-otp', data: model.toJson());
  }

  Future<Response> refreshToken(String refreshToken) async {
    return dio.post(
      '/auth/refresh',
      data: {
        'refreshToken': refreshToken,
        'refresh_token': refreshToken,
      },
    );
  }

  /// Creates the customer's initial profile via POST /customers/profile.
  ///
  /// Called from the Create Account screen which collects: firstName,
  /// lastName, nationalId, dateOfBirth, and mobileNumber.
  ///
  /// NOTE: The Create Account screen does not yet collect address fields.
  /// Address fields are sent as empty strings here and should be completed
  /// later from the Profile Details screen (ProfileDetailsView → ProfileProvider).
  ///
  /// UX GAP: The `address` (governorate, city, streetAddress) fields are
  /// required by the backend but not collected during account creation.
  /// The user should be prompted to complete them in ProfileDetailsView.
  Future<void> completeProfile({
    required String firstName,
    required String lastName,
    required String nationalId,
    required String dateOfBirth,
    required String mobileNumber,
    required String governorate,
    required String city,
    required String streetAddress,
  }) async {
    await dio.post(
      '/customers/profile',
      data: {
        'legalName': '$firstName $lastName',
        'dateOfBirth': dateOfBirth,
        'nationalIdNumber': nationalId,
        'address': {
          'governorate': governorate,
          'city': city,
          'streetAddress': streetAddress,
        },
        'mobileNumber': mobileNumber,
      },
    );
  }
}
