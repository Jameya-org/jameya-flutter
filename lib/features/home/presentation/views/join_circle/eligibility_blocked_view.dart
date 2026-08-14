import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/widgets/custom_button.dart';

/// Dead-end screen shown when the backend returns a 422 eligibility error
/// during join-intent or join. Displays the missing steps that the user
/// must complete before they can join any circle.
class EligibilityBlockedView extends StatelessWidget {
  const EligibilityBlockedView({
    super.key,
    required this.reason,
    required this.missingSteps,
  });
  final String reason;
  final List<String> missingSteps;

  String _arabicStep(String step) {
    switch (step) {
      case 'identity_verification':
        return 'التحقق من الهوية';
      case 'proof_of_income':
        return 'إثبات الدخل';
      case 'eligibility_decision':
        return 'قرار الأهلية';
      case 'kyc_verification':
        return 'التحقق من الهوية (KYC)';
      default:
        return step;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Icon ──────────────────────────────────────────
                Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 46.sp,
                    color: const Color(0xFFE87D3E),
                  ),
                ),
                SizedBox(height: 28.h),

                // ── Title ─────────────────────────────────────────
                Text(
                  'لا يمكنك الانضمام',
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),

                // ── Subtitle ──────────────────────────────────────
                Text(
                  'يجب إكمال الخطوات التالية قبل التمكن من الانضمام إلى أي جمعية.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),

                // ── Missing steps ─────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.grey200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'الخطوات المطلوبة',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ...missingSteps.map(
                        (step) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Row(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE87D3E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                _arabicStep(step),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // ── CTA ───────────────────────────────────────────
                CustomButton(
                  text: 'العودة للرئيسية',
                  onPressed: () => context.go(AppRoutes.kHomeView),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
