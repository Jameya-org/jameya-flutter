import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.homeRepo) : super(HomeInitial());

  final HomeRepo homeRepo;

  Future<void> loadHomeDashboard() async {
    emit(HomeLoading());

    try {
      final dashboard = await homeRepo.getHomeDashboard();
      emit(HomeSuccess(dashboard));
    } on DioException catch (e) {
      emit(
        HomeFailure(
          e.response?.data['message'] ?? e.message ?? 'حدث خطأ',
        ),
      );
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }
}
