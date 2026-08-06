import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/models/request_otp_model.dart';
import '../../data/models/verify_otp_model.dart';
import '../../data/repos/auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.authRepo) : super(AuthInitial());

  final AuthRepo authRepo;

  Future<void> requestOtp({required String email}) async {
    emit(RequestOtpLoading());

    try {
      await authRepo.requestOtp(RequestOtpModel(email: email));
      emit(RequestOtpSuccess());
    } on DioException catch (e) {
      emit(
        RequestOtpFailure(
          e.response?.data['message'] ?? e.message ?? 'حدث خطأ',
        ),
      );
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

      final accessToken = response.data['accessToken'] as String?;
      final refreshToken = response.data['refreshToken'] as String?;

      if (accessToken != null) {
        await getIt<CacheHelper>().saveData(
          key: 'accessToken',
          value: accessToken,
        );
        if (refreshToken != null) {
          await getIt<CacheHelper>().saveData(
            key: 'refreshToken',
            value: refreshToken,
          );
        }
        getIt<DioHelper>().setToken(accessToken);
      }

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