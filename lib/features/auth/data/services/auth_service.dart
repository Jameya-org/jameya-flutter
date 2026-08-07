import 'package:dio/dio.dart';

import '../models/request_otp_model.dart';
import '../models/verify_otp_model.dart';

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future<Response> requestOtp(RequestOtpModel model) async {
    return await dio.post(
      '/auth/request-otp',
      data: model.toJson(),
    );
  }

  Future<Response> verifyOtp(VerifyOtpModel model) async {
    return await dio.post(
      '/auth/verify-otp',
      data: model.toJson(),
    );
  }

  Future<Response> refreshToken(String refreshToken) async {
    return await dio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
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
  }) async {
    await dio.post(
      '/customers/profile',
      data: {
        'legalName': '$firstName $lastName',
        'dateOfBirth': dateOfBirth,
        'nationalIdNumber': nationalId,
        'address': {
          'governorate': '',
          'city': '',
          'streetAddress': '',
        },
        'mobileNumber': mobileNumber,
      },
    );
  }
}