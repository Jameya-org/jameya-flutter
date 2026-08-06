import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    debugPrint('[CirclesCubit] loadMyCircles starting...');
    emit(MyCirclesLoading());

    try {
      myCircles = await homeRepo.getMyCircles();
      debugPrint('[CirclesCubit] loadMyCircles success: ${myCircles.length} items');
      emit(MyCirclesSuccess(myCircles));
    } on DioException catch (e) {
      debugPrint('[CirclesCubit] loadMyCircles DioException: ${e.message}');
      emit(
        CirclesFailure(
          e.response?.data['message'] ?? e.message ?? 'حدث خطأ',
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('[CirclesCubit] loadMyCircles error: $e\n$stackTrace');
      emit(CirclesFailure(e.toString()));
    }
  }

  Future<void> loadAvailableCircles() async {
    debugPrint('[CirclesCubit] loadAvailableCircles starting...');
    emit(AvailableCirclesLoading());

    try {
      availableCircles = await homeRepo.getAvailableCircles();
      debugPrint('[CirclesCubit] loadAvailableCircles success: ${availableCircles.length} items');
      emit(AvailableCirclesSuccess(availableCircles));
    } on DioException catch (e) {
      debugPrint('[CirclesCubit] loadAvailableCircles DioException: ${e.message}');
      emit(
        CirclesFailure(
          e.response?.data['message'] ?? e.message ?? 'حدث خطأ',
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('[CirclesCubit] loadAvailableCircles error: $e\n$stackTrace');
      emit(CirclesFailure(e.toString()));
    }
  }
}
