import 'package:dio/dio.dart';

import '../models/request_otp_model.dart';
import '../models/verify_otp_model.dart';
import '../services/auth_service.dart';

class AuthRepo {
  final AuthService authService;

  AuthRepo(this.authService);

  Future<Response> requestOtp(RequestOtpModel model) async {
    return await authService.requestOtp(model);
  }

  Future<Response> verifyOtp(VerifyOtpModel model) async {
    return await authService.verifyOtp(model);
  }
}