import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/dio_error_utils.dart';
import '../../data/models/home_dashboard_model.dart';
import '../../data/repos/home_repo.dart';
import 'circles_state.dart';

class CirclesCubit extends Cubit<CirclesState> {
  CirclesCubit(this.homeRepo) : super(CirclesInitial());

  final HomeRepo homeRepo;

  List<CircleSummaryModel> availableCircles = [];
  List<MyCircleModel> myCircles = [];

  Future<void> loadMyCircles() async {
    emit(MyCirclesLoading());

    try {
      myCircles = await homeRepo.getMyCircles();
      emit(MyCirclesSuccess(myCircles));
    } on DioException catch (e) {
      emit(CirclesFailure(dioErrorMessage(e)));
    } catch (e, stackTrace) {
      emit(CirclesFailure('$e\n$stackTrace'));
    }
  }

  Future<void> loadAvailableCircles() async {
    emit(AvailableCirclesLoading());

    try {
      availableCircles = await homeRepo.getAvailableCircles();
      emit(AvailableCirclesSuccess(availableCircles));
    } on DioException catch (e) {
      emit(CirclesFailure(dioErrorMessage(e)));
    } catch (e, stackTrace) {
      emit(CirclesFailure('$e\n$stackTrace'));
    }
  }
}
