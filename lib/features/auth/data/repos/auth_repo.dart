import 'package:dio/dio.dart';

import '../models/request_otp_model.dart';
import '../models/verify_otp_model.dart';
import '../services/auth_service.dart';

class AuthRepo {
  AuthRepo(this.authService);
  final AuthService authService;

  Future<Response> requestOtp(RequestOtpModel model) async {
    return authService.requestOtp(model);
  }

  Future<Response> verifyOtp(VerifyOtpModel model) async {
    return authService.verifyOtp(model);
  }
}
