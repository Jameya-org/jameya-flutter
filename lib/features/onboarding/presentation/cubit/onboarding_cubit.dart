import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/models/onboarding_model.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingInitialState());

  static OnboardingCubit get(BuildContext context) => BlocProvider.of(context);

  int currentIndex = 0;

  bool get isLastPage => currentIndex == OnboardingModel.pageCount - 1;

  void onPageChanged(int index) {
    currentIndex = index;
    emit(OnboardingPageChangedState(index));
  }

  Future<void> completeOnboarding(BuildContext context) async {
    await getIt<CacheHelper>().saveData(
      key: 'isOnboardingCompleted',
      value: true,
    );
    if (context.mounted) {
      context.push(AppRoutes.kEmailView);
    }
  }
}
