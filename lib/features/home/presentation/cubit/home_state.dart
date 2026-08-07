import '../../data/models/home_dashboard_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  HomeSuccess(this.eligibility);
  final HomeEligibilityModel eligibility;
}

class HomeFailure extends HomeState {
  HomeFailure(this.message);
  final String message;
}
