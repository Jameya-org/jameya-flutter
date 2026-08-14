import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/dio_error_utils.dart';
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
      emit(HomeFailure(dioErrorMessage(e)));
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }
}
