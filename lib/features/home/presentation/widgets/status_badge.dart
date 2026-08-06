import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

/// Pill-shaped status badge matching the UI designs.
///
/// Supported statuses:
///  - "ACTIVE"   → green background, "نشطة"
///  - "FINISHED" → outlined, "منتهية"
///  - "OPEN"     → green dot + tint, "متاح للانضمام"
class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return _buildFilledBadge(
          label: 'نشطة',
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          textColor: AppColors.primary,
        );
      case 'FINISHED':
        return _buildOutlinedBadge(label: 'منتهية');
      case 'OPEN':
      default:
        return _buildDotBadge(label: 'متاح للانضمام');
    }
  }

  Widget _buildFilledBadge({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOutlinedBadge({required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.greyBut, width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: AppColors.textHint,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDotBadge({required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
