import 'package:dio/dio.dart';

import '../ models/request_otp_model.dart';
import '../ models/verify_otp_model.dart';
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/services/services_locator.dart';



class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future<Response> requestOtp(
      RequestOtpModel model,
      ) async {
    final response = await dio.post(
      '/auth/request-otp',
      data: model.toJson(),
    );

    print(response.data);

    return response;

  }

  Future<Response> verifyOtp(
      VerifyOtpModel model,
      ) async {
    return await dio.post(
      '/auth/verify-otp',
      data: model.toJson(),
    );
  }
  Future<void> completeProfile({
    required String firstName,
    required String lastName,
    required String nationalId,
    String? dateOfBirth,
    required String mobileNumber,
  }) async {
    final Map<String, dynamic> data = {
      'legalName': '$firstName $lastName',
      'nationalIdNumber': nationalId,
      'address': {
        'governorate': 'Dakahlia',
        'city': 'Talkha',
        'streetAddress': 'Unknown',
      },
      'mobileNumber': mobileNumber,
    };

    if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
      data['dateOfBirth'] = dateOfBirth;
    }
    print(data);
    await dio.post(
      '/customers/profile',
      data: data,
    );
  }
}