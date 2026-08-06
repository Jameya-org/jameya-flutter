import '../../data/models/home_dashboard_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final HomeDashboardModel dashboard;

  HomeSuccess(this.dashboard);
}

class HomeFailure extends HomeState {
  final String message;

  HomeFailure(this.message);
}
