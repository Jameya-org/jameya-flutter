import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/ models/request_otp_model.dart';
import '../../data/ models/verify_otp_model.dart';
import '../../data/ repos/auth_repo.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());

  final AuthRepo authRepo;

  Future<void> requestOtp({
    required String email,
  }) async {
    emit(RequestOtpLoading());

    try {
      print('before api');

      final response = await authRepo.requestOtp(
        RequestOtpModel(
          email: email,
        ),
      );

      print('status code: ${response.statusCode}');
      print('response: ${response.data}');

      emit(RequestOtpSuccess());
    } on DioException catch (e) {
      print('TYPE: ${e.type}');
      print('MESSAGE: ${e.message}');
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');

      emit(
        RequestOtpFailure(
          e.response?.data['message'] ??
              e.message ??'حدث خطأ',
        ),
      );
    } catch (e) {
      print(e);

      emit(
        RequestOtpFailure(
          e.toString(),
        ),
      );
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    emit(VerifyOtpLoading());

    try {
      final response = await authRepo.verifyOtp(
        VerifyOtpModel(
          email: email,
          otp: otp,
        ),
      );

      print(response.data);
      await getIt<CacheHelper>().saveData(
        key: 'accessToken',
        value: response.data['accessToken'],
      );

      await getIt<CacheHelper>().saveData(
        key: 'refreshToken',
        value: response.data['refreshToken'],
      );
      getIt<DioHelper>().setToken(
        response.data['accessToken'],
      );

      emit(VerifyOtpSuccess());
    } on DioException catch (e) {
      emit(
        VerifyOtpFailure(
          e.response?.data['message'] ?? 'حدث خطأ',
        ),
      );
    }
  }
}