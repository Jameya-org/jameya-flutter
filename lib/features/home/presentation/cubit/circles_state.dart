import '../../data/models/home_dashboard_model.dart';

abstract class CirclesState {}

class CirclesInitial extends CirclesState {}

class CirclesLoading extends CirclesState {}

class AvailableCirclesLoading extends CirclesState {}

class MyCirclesLoading extends CirclesState {}

class AvailableCirclesSuccess extends CirclesState {
  final List<CircleSummaryModel> circles;

  AvailableCirclesSuccess(this.circles);
}

class MyCirclesSuccess extends CirclesState {
  final List<CircleSummaryModel> circles;

  MyCirclesSuccess(this.circles);
}

class CirclesFailure extends CirclesState {
  final String message;

  CirclesFailure(this.message);
}
