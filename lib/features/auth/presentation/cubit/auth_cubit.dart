import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/cache/cache_keys.dart';
import '../../../../core/network/dio_error_utils.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/models/request_otp_model.dart';
import '../../data/models/verify_otp_model.dart';
import '../../data/repos/auth_repo.dart';
import 'auth_state.dart';

import '../../../../core/utils/token_utils.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());

  final AuthRepo authRepo;

  Future<void> requestOtp({required String email}) async {
    emit(RequestOtpLoading());

    try {
      await authRepo.requestOtp(RequestOtpModel(email: email));
      emit(RequestOtpSuccess());
    } on DioException catch (e) {
      emit(RequestOtpFailure(dioErrorMessage(e)));
    } catch (e) {
      emit(RequestOtpFailure(e.toString()));
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    emit(VerifyOtpLoading());

    try {
      final response = await authRepo.verifyOtp(
        VerifyOtpModel(email: email, otp: otp),
      );

      final accessToken = TokenUtils.extractAccessToken(response.data);
      final refreshToken = TokenUtils.extractRefreshToken(response.data);

      final cache = getIt<CacheHelper>();

      if (accessToken != null && accessToken.isNotEmpty) {
        await TokenUtils.saveTokens(
          cache,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }

      await cache.saveData(
        key: CacheKeys.email,
        value: email,
      );

      emit(VerifyOtpSuccess());
    } on DioException catch (e) {
      emit(VerifyOtpFailure(dioErrorMessage(e)));
    } catch (e) {
      emit(VerifyOtpFailure(e.toString()));
    }
  }
}