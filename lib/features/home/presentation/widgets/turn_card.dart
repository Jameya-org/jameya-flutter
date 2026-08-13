import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../data/models/home_dashboard_model.dart';

/// Turn/position selection card.
///
/// States:
///  - [isAvailable = false] → greyed out, not tappable.
///  - [isAvailable = true, isSelected = false] → white card with radio indicator.
///  - [isAvailable = true, isSelected = true] → teal background with checkmark.
class TurnCard extends StatelessWidget {
  const TurnCard({
    super.key,
    required this.position,
    required this.isSelected,
    required this.payoutDate,
    this.onTap,
  });
  final PositionModel position;
  final bool isSelected;
  final String payoutDate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool available = position.isAvailable;
    final Color bgColor = isSelected ? AppColors.primary : AppColors.surface;
    final Color textColor = isSelected
        ? Colors.white
        : available
        ? AppColors.textPrimary
        : AppColors.textDisabled;
    final Color subtitleColor = isSelected
        ? Colors.white.withValues(alpha: 0.85)
        : available
        ? AppColors.textHint
        : AppColors.textDisabled;
    final Color discountColor = isSelected
        ? Colors.white.withValues(alpha: 0.9)
        : AppColors.primary;
    final Color borderColor = isSelected
        ? AppColors.primary
        : AppColors.grey200;

    return GestureDetector(
      onTap: available ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── Right side: turn number + date ──────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الدور ${position.position}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'موعد القبض: $payoutDate',
                  style: AppTextStyles.label.copyWith(
                    color: subtitleColor,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),

            // ── Left side: indicator + discount ─────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Selection indicator / availability badge
                if (isSelected)
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 14.sp,
                      color: AppColors.primary,
                    ),
                  )
                else if (available)
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.grey500, width: 1.5),
                    ),
                  )
                else
                  Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: const BoxDecoration(
                      color: AppColors.grey200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.block,
                      size: 12.sp,
                      color: AppColors.textDisabled,
                    ),
                  ),
                SizedBox(height: 4.h),
                // Availability label
                Text(
                  available ? 'متاح' : 'غير متاح',
                  style: AppTextStyles.label.copyWith(
                    color: subtitleColor,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                // Fee / discount percentage label
                Text(
                  _formatFeeLabel(position.feePreview.feePercentage),
                  style: AppTextStyles.label.copyWith(
                    color: discountColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatFeeLabel(String feePercentageStr) {
    final val = double.tryParse(feePercentageStr) ?? 0.0;
    if (val < 0) {
      final absVal = val.abs();
      final formatted = absVal % 1 == 0 ? absVal.toInt() : absVal;
      return 'نسبة الخصم: $formatted%';
    } else if (val > 0) {
      final formatted = val % 1 == 0 ? val.toInt() : val;
      return 'نسبة الرسوم: $formatted%';
    } else {
      return 'بدون رسوم إضافية';
    }
  }
}
