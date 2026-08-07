import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

/// A horizontal dots-based progress indicator matching the UI designs.
///
/// Dots to the left of [currentTurn] are filled teal (completed),
/// the dot at [currentTurn] is a larger outlined teal dot (current),
/// and dots to the right are light grey (remaining).
class ProgressDotsIndicator extends StatelessWidget {
  const ProgressDotsIndicator({
    super.key,
    required this.currentTurn,
    required this.totalTurns,
  });
  final int currentTurn;
  final int totalTurns;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.h,
      child: Row(
        children: List.generate(totalTurns, (index) {
          final turnNumber = index + 1;
          final isCompleted = turnNumber < currentTurn;
          final isCurrent = turnNumber == currentTurn;

          if (isCurrent) {
            return Expanded(
              child: Center(
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Expanded(
            child: Center(
              child: Container(
                width: isCompleted ? 8.w : 7.w,
                height: isCompleted ? 8.w : 7.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? AppColors.primary : AppColors.grey200,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
