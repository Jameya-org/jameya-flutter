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

  Future<void> completeProfile({
    required String firstName,
    required String lastName,
    required String nationalId,
    required String dateOfBirth,
    required String mobileNumber,
  }) async {
    final Map<String, dynamic> data = {
      'legalName': '$firstName $lastName',
      'dateOfBirth': dateOfBirth,
      'nationalIdNumber': nationalId,
      'mobileNumber': mobileNumber,
    };

    await dio.post(
      '/customers/profile',
      data: data,
    );
  }
}