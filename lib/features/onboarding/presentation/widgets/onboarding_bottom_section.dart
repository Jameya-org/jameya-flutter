import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../generated/l10n.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import 'onboarding_dots_indicator.dart';

class OnboardingBottomSection extends StatelessWidget {
  final int totalPages;
  final VoidCallback onNextPressed;

  const OnboardingBottomSection({
    super.key,
    required this.totalPages,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = MediaQuery.of(context).size.height < 500;
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final isLast = context.read<OnboardingCubit>().isLastPage;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OnboardingDotsIndicator(
                count: totalPages,
                currentIndex: context.read<OnboardingCubit>().currentIndex,
              ),
              SizedBox(height: isLandscape ? 12.h : 32.h),
              CustomButton(
                text: isLast ? S.of(context).start : S.of(context).next,
                onPressed: onNextPressed,
                height: isLandscape ? 40.h : 56.h,
              ),
            ],
          ),
        );
      },
    );
  }
}
