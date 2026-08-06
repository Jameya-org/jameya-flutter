import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/home_repo.dart';
import 'circles_state.dart';

class CirclesCubit extends Cubit<CirclesState> {
  CirclesCubit(this.homeRepo) : super(CirclesInitial());

  final HomeRepo homeRepo;

  Future<void> loadMyCircles() async {
    emit(CirclesLoading());

    try {
      final circles = await homeRepo.getMyCircles();
      emit(CirclesSuccess(circles));
    } on DioException catch (e) {
      emit(
        CirclesFailure(
          e.response?.data['message'] ?? e.message ?? 'حدث خطأ',
        ),
      );
    } catch (e) {
      emit(CirclesFailure(e.toString()));
    }
  }

  Future<void> loadAvailableCircles() async {
    emit(CirclesLoading());

    try {
      final circles = await homeRepo.getAvailableCircles();
      emit(CirclesSuccess(circles));
    } on DioException catch (e) {
      emit(
        CirclesFailure(
          e.response?.data['message'] ?? e.message ?? 'حدث خطأ',
        ),
      );
    } catch (e) {
      emit(CirclesFailure(e.toString()));
    }
  }
}
