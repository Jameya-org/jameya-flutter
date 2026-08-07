import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../data/models/home_dashboard_model.dart';
import 'progress_dots_indicator.dart';
import 'status_badge.dart';

/// Card used in the Progress view showing a circle's progress via dots indicator.
class CircleProgressCard extends StatelessWidget {
  const CircleProgressCard({super.key, required this.circle});
  final dynamic circle;

  @override
  Widget build(BuildContext context) {
    int currentStep = 0;
    int totalSteps = 1;
    final String status = circle.status?.toString() ?? '';
    final String title = circle.title?.toString() ?? '';

    if (circle is MyCircleModel) {
      currentStep = circle.currentInstallment;
      totalSteps = circle.totalInstallments > 0 ? circle.totalInstallments : 1;
    } else if (circle is CircleSummaryModel) {
      currentStep = circle.currentMembersCount;
      totalSteps = circle.memberCapacity > 0 ? circle.memberCapacity : 1;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Top row: badge + title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusBadge(status: status),
              Text(
                title,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Members label
          Text(
            'الأعضاء',
            style: AppTextStyles.label.copyWith(color: AppColors.textHint),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 2.h),
          Text(
            '$currentStep/$totalSteps',
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 12.h),

          // Progress dots
          ProgressDotsIndicator(
            currentTurn: currentStep,
            totalTurns: totalSteps,
          ),
        ],
      ),
    );
  }
}
