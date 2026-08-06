import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';

/// "Complete Your Information" dialog ("كمل بياناتك") shown when an unverified
/// or incomplete user attempts to start the Join Circle flow.
class CompleteProfileDialog extends StatelessWidget {
  const CompleteProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: AppColors.surface,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Top icon container ──────────────────────────────
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F7F7),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.badge_outlined,
                  size: 32.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 20.h),

              // ── Title ───────────────────────────────────────────
              Text(
                'كمل بياناتك',
                style: AppTextStyles.subtitle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 20.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),

              // ── Subtitle ────────────────────────────────────────
              Text(
                'بيانات اساسية علشان نسهل عليك استخدام تطبيق جمعية.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                  height: 1.5,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // ── Primary CTA button "التالي" ───────────────────────
              CustomButton(
                text: 'التالي',
                onPressed: () {
                  // Capture the router before popping the dialog so we don't
                  // navigate with a context whose route is being deactivated.
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop(); // dismiss dialog
                  router.push(AppRoutes.kKycVerificationView);
                },
                height: 50.h,
                borderRadius: 12.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
