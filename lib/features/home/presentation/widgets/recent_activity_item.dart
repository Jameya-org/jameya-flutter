import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/assets.dart';

/// Single row item for displaying a recent activity.
/// Note: The /customer/home endpoint no longer returns recent activities.
/// This widget is kept for future use when activity data becomes available.
class RecentActivityItem extends StatelessWidget {
  const RecentActivityItem({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.createdAt,
  });
  final String type;
  final String title;
  final String description;
  final String createdAt;

  String _formatTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour < 12 ? 'صباحاً' : 'مساءً';
      return '$hour:$minute $period';
    } catch (_) {
      return '';
    }
  }

  String _getActivityIcon(String type) {
    switch (type.toUpperCase()) {
      case 'PAYMENT':
        return Assets.iconsMoney;
      case 'JOIN':
        return Assets.iconsAddPerson;
      default:
        return Assets.iconsCalendarCheck;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: icon container
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                _getActivityIcon(type),
                width: 20.w,
                height: 20.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Right: text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  description,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _formatTime(createdAt),
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textHint,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    SvgPicture.asset(
                      Assets.iconsClockCircle,
                      width: 12.w,
                      height: 12.w,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textHint,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
