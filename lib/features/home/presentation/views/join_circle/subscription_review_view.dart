import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../cubit/join_circle_cubit.dart';
import '../../cubit/join_circle_state.dart';
import '../../widgets/join_flow_shared.dart';
import '../../widgets/join_info_box.dart';
import '../../widgets/join_step_indicator.dart';

/// Step 4/7 — Subscription Review.
///
/// Tapping "التالي" calls [JoinCircleCubit.submitJoin].
/// • 201 → navigate to Contract Review
/// • 409 → dialog, pop back to Select Turn, refresh positions
/// • 422 → navigate to EligibilityBlockedView
/// • network → snackbar, re-enable button
class SubscriptionReviewView extends StatefulWidget {
  const SubscriptionReviewView({super.key, required this.circleId});
  final String circleId;

  @override
  State<SubscriptionReviewView> createState() => _SubscriptionReviewViewState();
}

class _SubscriptionReviewViewState extends State<SubscriptionReviewView> {
  bool _isSubmitting = false;

  String _formatAmount(String amount) {
    try {
      final value = double.parse(amount);
      return '${NumberFormat('#,###').format(value.toInt())} ج.م';
    } catch (_) {
      return '$amount ج.م';
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '—';
    try {
      final date = DateTime.parse(dateStr);
      const months = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ];
      return '${date.day} ${months[date.month - 1]}';
    } catch (_) {
      return dateStr;
    }
  }

  void _onNext(BuildContext context) {
    setState(() => _isSubmitting = true);
    context.read<JoinCircleCubit>().submitJoin();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JoinCircleCubit, JoinCircleState>(
      listener: (context, state) {
        if (state is JoinCircleJoinSuccess) {
          setState(() => _isSubmitting = false);
          final cubit = context.read<JoinCircleCubit>();
          context.push(
            AppRoutes.contractReviewPath(widget.circleId),
            extra: cubit,
          );
        }

        if (state is JoinCirclePositionTaken) {
          setState(() => _isSubmitting = false);
          _showPositionTakenDialog(context);
        }

        if (state is JoinCircleIntentBlocked) {
          setState(() => _isSubmitting = false);
          context.push(
            AppRoutes.eligibilityBlockedPath(widget.circleId),
            extra: {'reason': state.reason, 'missingSteps': state.missingSteps},
          );
        }

        if (state is JoinCircleJoinFailure) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<JoinCircleCubit>();
        final detail = cubit.circleDetail;
        final selected = cubit.selectedPosition;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ──────────────────────────────────
                  JoinFlowHeader(
                    title: 'مراجعة الاشتراك',
                    onBack: () => context.pop(),
                  ),
                  SizedBox(height: 12.h),
                  const JoinStepIndicator(currentStep: 4),
                  SizedBox(height: 20.h),

                  // ── Body ────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Summary card
                          Container(
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
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              children: [
                                _ReviewRow(
                                  label: 'اسم الجمعية',
                                  value: detail?.title ?? '—',
                                ),
                                _ReviewRow(
                                  label: 'الدور المختار',
                                  value: selected != null
                                      ? 'الدور ${selected.position}'
                                      : '—',
                                ),
                                _ReviewRow(
                                  label: 'قيمة القسط',
                                  value: _formatAmount(
                                    detail?.contributionAmount ?? '0',
                                  ),
                                ),
                                _ReviewRow(
                                  label: 'عدد الاعضاء',
                                  value:
                                      '${detail?.currentMembersCount ?? 0} اعضاء',
                                ),
                                _ReviewRow(
                                  label: 'تاريخ البداية',
                                  value: _formatDate(detail?.startDate ?? ''),
                                ),
                                _ReviewRow(
                                  label: 'تاريخ القبض',
                                  value: selected != null
                                      ? cubit.computePayoutDate(
                                          selected.position,
                                        )
                                      : '—',
                                ),
                                // TODO(BUG-03 / LOGIC-01): Payment method value
                            // is hardcoded. When the backend requires a real
                            // paymentMethodId in POST /customer/circles/{id}/join,
                            // this must display the user's selected method.
                            const _ReviewRow(
                                  label: 'طريقة الدفع',
                                  value: 'بطاقة بنكية',
                                  showDivider: false,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),

                          const JoinInfoBox(
                            message:
                                'يرجى مراجعة جميع التفاصيل بدقة قبل المتابعة. لا يمكن تعديل الدور بعد تأكيد الاشتراك.',
                          ),

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),

                  // ── Bottom button ────────────────────────────
                  JoinFlowBottomBar(
                    label: 'التالي',
                    enabled: !_isSubmitting,
                    isLoading: _isSubmitting,
                    onTap: () => _onNext(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPositionTakenDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'الدور غير متاح',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
          content: Text(
            'الدور الذي اخترته أصبح محجوزاً. سيتم إعادتك لاختيار دور آخر.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final cubit = context.read<JoinCircleCubit>();
                cubit.loadPositions(forceRefresh: true);

                // Dismiss the dialog first.
                Navigator.pop(context);

                // Navigate back to SelectTurnView safely by replacing the
                // current stack segment rather than doing sequential pops
                // which can fail if the context becomes unmounted mid-pop.
                context.pushReplacement(
                  AppRoutes.selectTurnPath(widget.circleId),
                  extra: cubit,
                );
              },
              child: Text(
                'اختر دوراً آخر',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}
