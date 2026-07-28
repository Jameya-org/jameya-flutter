import 'package:flutter/material.dart';
import 'package:jameya/core/utils/app_colors.dart';
import 'package:jameya/features/onboarding/presentation/view/widgets/onboarding_view_body.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.surface,
      body: OnboardingViewBody(),
    );
  }
}
