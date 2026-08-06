import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../cubit/join_circle_cubit.dart';
import '../../cubit/join_circle_state.dart';
import '../../widgets/join_flow_shared.dart';
import '../../widgets/join_info_row.dart';
import '../../widgets/join_step_indicator.dart';
import 'eligibility_blocked_view.dart';

/// Step 1/7 — Circle Details.
///
/// On mount: calls [JoinCircleCubit.checkIntentAndLoadDetail].
/// Navigates to [EligibilityBlockedView] on 422, shows detail on success.
class CircleDetailView extends StatefulWidget {
  final String circleId;

  const CircleDetailView({super.key, required this.circleId});

  @override
  State<CircleDetailView> createState() => _CircleDetailViewState();
}

class _CircleDetailViewState extends State<CircleDetailView> {
  @override
  void initState() {
    super.initState();
    context.read<JoinCircleCubit>().checkIntentAndLoadDetail(widget.circleId);
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '—';
    try {
      final date = DateTime.parse(dateStr);
      const arabicMonths = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
      ];
      return '${date.day} ${arabicMonths[date.month - 1]}';
    } catch (_) {
      return dateStr;
    }
  }

  String _formatAmount(String amount) {
    try {
      final value = double.parse(amount);
      return '${NumberFormat('#,###').format(value.toInt())} ج.م';
    } catch (_) {
      return '$amount ج.م';
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
      case 'UPCOMING':
        return 'متاحة للانضمام';
      case 'ACTIVE':
        return 'نشطة';
      case 'FINISHED':
        return 'منتهية';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JoinCircleCubit, JoinCircleState>(
      listener: (context, state) {
        if (state is JoinCircleIntentBlocked) {
          context.push(
            AppRoutes.eligibilityBlockedPath(widget.circleId),
            extra: {
              'reason': state.reason,
              'missingSteps': state.missingSteps,
            },
          );
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ──────────────────────────────────────
                  JoinFlowHeader(
                    title: 'تفاصيل الجمعية',
                    onBack: () => context.pop(),
                  ),
                  SizedBox(height: 12.h),
                  const JoinStepIndicator(currentStep: 1),
                  SizedBox(height: 20.h),

                  // ── Body ─────────────────────────────────────────
                  Expanded(
                    child: _buildBody(context, state),
                  ),

                  // ── Bottom button ────────────────────────────────
                  JoinFlowBottomBar(
                    label: 'التالي',
                    enabled: state is JoinCircleDetailReady,
                    onTap: () {
                      final cubit = context.read<JoinCircleCubit>();
                      context.push(
                        AppRoutes.selectTurnPath(widget.circleId),
                        extra: cubit,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, JoinCircleState state) {
    if (state is JoinCircleIntentLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state is JoinCircleIntentError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded, size: 48.sp, color: AppColors.textHint),
              SizedBox(height: 16.h),
              Text(
                state.message,
                style: AppTextStyles.body.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              CustomButton(
                text: 'إعادة المحاولة',
                onPressed: () => context
                    .read<JoinCircleCubit>()
                    .checkIntentAndLoadDetail(widget.circleId),
              ),
            ],
          ),
        ),
      );
    }

    final cubit = context.read<JoinCircleCubit>();
    final detail = cubit.circleDetail;
    if (detail == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'عن الجمعية',
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'معلومات تفصيلية عن الجمعية',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          ),
          SizedBox(height: 20.h),

          // Info rows
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
                JoinInfoRow(
                  svgIconPath: Assets.iconsGroupOfUsers,
                  label: 'عدد الاعضاء',
                  value: '${detail.currentMembersCount} عضو',
                ),
                JoinInfoRow(
                  svgIconPath: Assets.iconsCalendarDots,
                  label: 'بداية الجمعية',
                  value: _formatDate(detail.startDate),
                ),
                JoinInfoRow(
                  svgIconPath: Assets.iconsMoney,
                  label: 'القسط الشهري',
                  value: _formatAmount(detail.contributionAmount),
                ),
                JoinInfoRow(
                  svgIconPath: Assets.iconsClockCircle,
                  label: 'مدة الجمعية',
                  value: '${detail.durationMonths} شهر',
                ),
                JoinInfoRow(
                  svgIconPath: Assets.iconsCalendarCheck,
                  label: 'الحالة',
                  value: _statusLabel(detail.status),
                  showDivider: false,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
