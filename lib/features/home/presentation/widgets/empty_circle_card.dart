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
  final VoidCallback onBrowseCircles;

  const EmptyCircleCard({super.key, required this.onBrowseCircles});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Title row with wallet icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet icon container
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.iconsWallet,
                    width: 24.w,
                    height: 24.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textHint,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              // Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'ابدأ أول جمعية لك',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      'انضم إلى جمعية تناسبك وابدأ الادخار بخطوات بسيطة.',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textHint,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // CTA button
          CustomButton(
            text: 'عرض الجمعيات',
            onPressed: onBrowseCircles,
            height: 48.h,
            borderRadius: 12.r,
          ),
        ],
      ),
    );
  }
}
