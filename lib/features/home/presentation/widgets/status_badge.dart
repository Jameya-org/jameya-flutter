import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

/// Pill-shaped status badge matching the UI designs.
///
/// Supported statuses:
///  - "ACTIVE"   → teal background, "نشطة"
///  - "FINISHED" → outlined, "منتهية"
///  - "UPCOMING" → light teal background + green dot, "متاح الانضمام"
///  - "OPEN"     → light teal background + green dot, "متاح الانضمام"
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});
  final String status;

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
      case 'UPCOMING':
      case 'OPEN':
      default:
        return _buildDotBadge(label: 'متاح الانضمام');
    }
  }

  Widget _buildFilledBadge({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildOutlinedBadge({required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildDotBadge({required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F7F7),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Green dot
          Container(
            width: 7.w,
            height: 7.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2DB87A),
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
