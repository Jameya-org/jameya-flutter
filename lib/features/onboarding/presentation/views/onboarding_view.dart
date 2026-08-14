import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../widgets/onboarding_view_body.dart';

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
