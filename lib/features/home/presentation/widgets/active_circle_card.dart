import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../data/models/home_dashboard_model.dart';
import 'status_badge.dart';

/// Teal gradient card showing the user's current active circle.
class ActiveCircleCard extends StatelessWidget {
  final ActiveCircleModel circle;

  const ActiveCircleCard({super.key, required this.circle});

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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00A6A5), Color(0xFF007A7A)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Top row: label + status badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusBadge(status: circle.status),
              Text(
                'جمعيتك الحالية',
                style: AppTextStyles.label.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Circle title
          Text(
            circle.title,
            style: AppTextStyles.title.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22.sp,
            ),
          ),
          SizedBox(height: 16.h),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                icon: Assets.iconsGroupOfUsers,
                label: 'الأعضاء',
                value: circle.membersCount.toString(),
              ),
              _StatItem(
                icon: Assets.iconsRefresh,
                label: 'دورك',
                value: circle.currentTurn.toString(),
              ),
              _StatItem(
                icon: Assets.iconsCalendarDots,
                label: 'تاريخ الدفع',
                value: _formatPaymentDate(circle.paymentDate),
              ),
              _StatItem(
                icon: Assets.iconsMoney,
                label: 'المبلغ الشهري',
                value: _formatAmount(circle.monthlyAmount),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          icon,
          width: 18.w,
          height: 18.w,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}
