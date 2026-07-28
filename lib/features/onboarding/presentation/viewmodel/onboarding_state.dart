abstract class OnboardingState {
  const OnboardingState();
}

class OnboardingInitialState extends OnboardingState {
  const OnboardingInitialState();
}

class OnboardingPageChangedState extends OnboardingState {
  final int pageIndex;
  const OnboardingPageChangedState(this.pageIndex);
}
