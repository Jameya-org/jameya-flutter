import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jameya/core/cache/cache_helper.dart';
import 'package:jameya/core/services/services_locator.dart';
import 'package:jameya/features/onboarding/data/models/onboarding_model.dart';
import 'package:jameya/features/onboarding/presentation/viewmodel/onboarding_state.dart';

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
      // TODO: navigate to login/auth screen when ready
      // context.go(AppRoutes.kLoginView);
    }
  }
}
