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
/// Used in: available circles, recommended circles.
class CircleCard extends StatelessWidget {
  final CircleSummaryModel circle;
  final VoidCallback? onTap;

  const CircleCard({super.key, required this.circle, this.onTap});

  String _formatPaymentDate(String dateStr) {
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

  String _formatAmount(double amount) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(amount.toInt())} ج.م';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Top row: title + monthly amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Monthly amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'القسط الشهري',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _formatAmount(circle.monthlyAmount),
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                // Title
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
            SizedBox(height: 10.h),

            // Bottom row: status badge + members + date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Members + date on the left
                Row(
                  children: [
                    _InfoChip(
                      icon: Assets.iconsCalendarDots,
                      label: _formatPaymentDate(circle.paymentDate),
                    ),
                    SizedBox(width: 12.w),
                    _InfoChip(
                      icon: Assets.iconsGroupOfUsers,
                      label: '${circle.membersCount} عضو',
                    ),
                  ],
                ),
                // Status badge on the right
                StatusBadge(status: circle.status),
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
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: AppColors.textHint,
          ),
        ),
        SizedBox(width: 4.w),
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
