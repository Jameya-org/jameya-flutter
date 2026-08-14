import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/custom_button.dart';

/// Empty state card shown when user has no active circle.
/// Contains title, subtitle, and CTA button to browse circles.
class EmptyCircleCard extends StatelessWidget {
  const EmptyCircleCard({super.key, required this.onBrowseCircles});
  final VoidCallback onBrowseCircles;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Title row: text (right) | wallet icon (left) ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text section — first child = right side in RTL
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ابدأ أول جمعية لك',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'انضم إلى جمعية تناسبك وابدأ الادخار بخطوات بسيطة.',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textHint,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),

              // Wallet icon container — last child = left side in RTL
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F7F7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.iconsWallet,
                    width: 26.w,
                    height: 26.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // ── CTA button — full width ──
          CustomButton(
            text: 'عرض الجمعيات',
            onPressed: onBrowseCircles,
            height: 52.h,
            borderRadius: 12.r,
          ),
        ],
      ),
    );
  }
}
