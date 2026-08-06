import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/home_dashboard_model.dart';
import '../../data/repos/home_repo.dart';
import 'circles_state.dart';

class CirclesCubit extends Cubit<CirclesState> {
  CirclesCubit(this.homeRepo) : super(CirclesInitial());

  final HomeRepo homeRepo;

  List<CircleSummaryModel> availableCircles = [];
  List<CircleSummaryModel> myCircles = [];

  Future<void> loadMyCircles() async {
    emit(CirclesLoading());

    try {
      myCircles = await homeRepo.getMyCircles();
      emit(MyCirclesSuccess(myCircles));
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
      availableCircles = await homeRepo.getAvailableCircles();
      emit(AvailableCirclesSuccess(availableCircles));
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
