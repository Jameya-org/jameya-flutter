import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

/// A continuous 7-segment progress bar that advances one segment per screen
/// in the join circle flow. Purely visual — no step count is shown to the user.
///
/// [currentStep] is 1-based (1 = first screen, 7 = success screen).
/// [totalSteps] defaults to 7.
class JoinStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const JoinStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 7,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isFilled = index < currentStep;
          final isFirst = index == 0;
          final isLast = index == totalSteps - 1;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              height: 4.h,
              margin: EdgeInsets.only(
                left: isLast ? 0 : 3.w,
              ),
              decoration: BoxDecoration(
                color: isFilled ? AppColors.primary : AppColors.grey200,
                borderRadius: BorderRadius.horizontal(
                  left: isLast ? const Radius.circular(4) : Radius.zero,
                  right: isFirst ? const Radius.circular(4) : Radius.zero,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
