import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../data/models/home_dashboard_model.dart';
import 'progress_dots_indicator.dart';
import 'status_badge.dart';

/// Card used in the Progress view showing a circle's progress via dots indicator.
class CircleProgressCard extends StatelessWidget {
  final CircleSummaryModel circle;

  const CircleProgressCard({super.key, required this.circle});

  @override
  Widget build(BuildContext context) {
    final currentTurn = circle.currentTurn ?? 0;
    final totalTurns = circle.totalTurns ?? 1;

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
              StatusBadge(status: circle.status),
              Text(
                circle.title,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Current turn label
          Text(
            'الدور الحالي',
            style: AppTextStyles.label.copyWith(
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 2.h),
          Text(
            '$currentTurn/$totalTurns',
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
            currentTurn: currentTurn,
            totalTurns: totalTurns,
          ),
        ],
      ),
    );
  }
}
