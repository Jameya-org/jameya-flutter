import '../../data/models/home_dashboard_model.dart';

abstract class CirclesState {}

class CirclesInitial extends CirclesState {}

class CirclesLoading extends CirclesState {}

class AvailableCirclesLoading extends CirclesState {}

class MyCirclesLoading extends CirclesState {}

class AvailableCirclesSuccess extends CirclesState {
  AvailableCirclesSuccess(this.circles);
  final List<CircleSummaryModel> circles;
}

class MyCirclesSuccess extends CirclesState {
  MyCirclesSuccess(this.circles);
  final List<MyCircleModel> circles;
}

class CirclesFailure extends CirclesState {
  CirclesFailure(this.message);
  final String message;
}
