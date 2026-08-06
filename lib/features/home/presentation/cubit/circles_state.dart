import '../../data/models/home_dashboard_model.dart';

abstract class CirclesState {}

class CirclesInitial extends CirclesState {}

class CirclesLoading extends CirclesState {}

class CirclesSuccess extends CirclesState {
  final List<CircleSummaryModel> circles;

  CirclesSuccess(this.circles);
}

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
