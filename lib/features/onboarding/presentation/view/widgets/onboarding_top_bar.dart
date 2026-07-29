import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jameya/core/utils/app_colors.dart';
import 'package:jameya/core/utils/app_text_styles.dart';
import 'package:jameya/generated/l10n.dart';
import 'package:jameya/features/onboarding/presentation/viewmodel/onboarding_cubit.dart';
import 'package:jameya/features/onboarding/presentation/viewmodel/onboarding_state.dart';

class OnboardingTopBar extends StatelessWidget {
  final int totalPages;
  final VoidCallback onSkipPressed;

  final VoidCallback onBackPressed;

  const OnboardingTopBar({
    super.key,
    required this.totalPages,
    required this.onSkipPressed,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = MediaQuery.of(context).size.height < 500;
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        final bool isLast = cubit.isLastPage;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: isLandscape ? 6.h : 16.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button (Arabic: right side is leading in RTL)
              GestureDetector(
                onTap: onBackPressed,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18.r,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                opacity: isLast ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onTap: isLast ? null : onSkipPressed,
                  child: Text(
                    S.of(context).skip,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
