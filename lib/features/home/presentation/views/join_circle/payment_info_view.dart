import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../cubit/join_circle_cubit.dart';
import '../../widgets/join_flow_shared.dart';
import '../../widgets/join_step_indicator.dart';

/// Step 3/7 — Payment Information.
///
/// Static informational screen — no API call.
/// Explains how the bank card will be used and data protection guarantees.
class PaymentInfoView extends StatelessWidget {
  final String circleId;

  const PaymentInfoView({super.key, required this.circleId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<JoinCircleCubit>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ──────────────────────────────────────────
              JoinFlowHeader(
                title: 'طريقة الدفع',
                onBack: () => context.pop(),
              ),
              SizedBox(height: 12.h),
              const JoinStepIndicator(currentStep: 3),
              SizedBox(height: 20.h),

              // ── Body ─────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Card 1 — Bank card
                      _InfoCard(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'بطاقة بنكية',
                                    style: AppTextStyles.body.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    'سيتم استخدام البطاقة للدفع و استلام مستحقات الجمعية عند حلول دورك',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textHint,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Container(
                              width: 44.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F7F7),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.credit_card_rounded,
                                size: 22.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Card 2 — Data protection
                      _InfoCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'حماية بياناتك',
                                        style: AppTextStyles.body.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      const _BulletItem(
                                        text: 'لن يتم حفظ بياناتك بطاقتك داخل التطبيق .',
                                      ),
                                      const _BulletItem(
                                        text: 'سيتم ادخال بيانات البطاقة داخل بوابة دفع امنة .',
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Container(
                                  width: 44.w,
                                  height: 44.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F7F7),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.shield_outlined,
                                    size: 22.sp,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16.h),
                            Divider(height: 1, color: AppColors.divider),
                            SizedBox(height: 16.h),

                            Text(
                              'ستستخدم البطاقة في :',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            const _BulletItem(text: 'خصم قيمة القسط الشهري.'),
                            const _BulletItem(text: 'تحويل القبض عند حلول دورك'),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),

              // ── Bottom button ─────────────────────────────────────
              JoinFlowBottomBar(
                label: 'الي بوابة الدفع',
                enabled: true,
                onTap: () => context.push(
                  AppRoutes.subscriptionReviewPath(circleId),
                  extra: cubit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 6.w),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
