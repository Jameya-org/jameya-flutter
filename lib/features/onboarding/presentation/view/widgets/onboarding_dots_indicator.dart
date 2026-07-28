import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jameya/core/utils/app_colors.dart';

class OnboardingDotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingDotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) {
          final bool isActive = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            height: 8.h,
            width: isActive ? 28.w : 8.w,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : AppColors.grey300,
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        },
      ),
    );
  }
}
