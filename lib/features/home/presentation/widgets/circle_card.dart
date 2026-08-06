import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../data/models/home_dashboard_model.dart';
import 'status_badge.dart';

/// Reusable card for displaying a circle summary in lists.
/// Used in: home screen (inline preview), available circles page.
class CircleCard extends StatelessWidget {
  final CircleSummaryModel circle;
  final VoidCallback? onTap;

  const CircleCard({super.key, required this.circle, this.onTap});

  String _formatStartDate(String dateStr) {
    if (dateStr.isEmpty) return '—';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day} ${_arabicMonth(date.month)}';
    } catch (_) {
      return dateStr;
    }
  }

  String _arabicMonth(int month) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
    ];
    return months[month - 1];
  }

  String _formatAmount(String amount) {
    try {
      final value = double.parse(amount);
      final formatter = NumberFormat('#,###');
      return '${formatter.format(value.toInt())} ج.م';
    } catch (_) {
      return '$amount ج.م';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.grey200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Top row: title (right) | status badge (left) ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // First child = right in RTL → Circle title
                Text(
                  circle.title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontSize: 17.sp,
                  ),
                ),
                // Last child = left in RTL → Status badge
                StatusBadge(status: circle.status),
              ],
            ),

            SizedBox(height: 16.h),

            // ── Bottom row: amount (right) | members+date (left) ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // First child = right in RTL → Monthly instalment
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'القسط الشهري',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textHint,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      _formatAmount(circle.contributionAmount),
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),

                // Last child = left in RTL → Members count + start date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _InfoChip(
                      icon: Assets.iconsGroupOfUsers,
                      label:
                          '${circle.currentMembersCount} عضو',
                    ),
                    SizedBox(height: 6.h),
                    _InfoChip(
                      icon: Assets.iconsCalendarDots,
                      label: _formatStartDate(circle.startDate),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Last child in RTL Row = left side (text reads right to icon)
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.textHint,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(width: 5.w),
        SvgPicture.asset(
          icon,
          width: 14.w,
          height: 14.w,
          colorFilter: const ColorFilter.mode(
            AppColors.textHint,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }
}
