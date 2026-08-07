import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../cubit/join_circle_cubit.dart';
import '../../cubit/join_circle_state.dart';
import '../../widgets/join_flow_shared.dart';
import '../../widgets/join_info_box.dart';
import '../../widgets/join_step_indicator.dart';

/// Step 5/7 — Contract Review.
///
/// Shows the contract card + 3 mandatory checkboxes.
/// "ارسل رمز التحقق" calls [JoinCircleCubit.acceptContract] which triggers OTP.
/// • 200 → navigate to OTP screen
/// • 410 → reservation expired dialog → navigate back to Subscription Review
/// • network → snackbar, re-enable button
class ContractReviewView extends StatefulWidget {
  const ContractReviewView({super.key, required this.circleId});
  final String circleId;

  @override
  State<ContractReviewView> createState() => _ContractReviewViewState();
}

class _ContractReviewViewState extends State<ContractReviewView> {
  bool _agreedToLateFees = false;
  bool _agreedToInstallments = false;
  bool _agreedToTerms = false;

  bool get _allChecked =>
      _agreedToLateFees && _agreedToInstallments && _agreedToTerms;
  bool _isSubmitting = false;

  Future<void> _onViewContract() async {
    final cubit = context.read<JoinCircleCubit>();
    final downloadUrl = cubit.contract?.downloadUrl ?? '';
    if (downloadUrl.isEmpty) return;

    final fullUrl = downloadUrl.startsWith('http')
        ? downloadUrl
        : 'https://jameya-backend.onrender.com$downloadUrl';

    final uri = Uri.parse(fullUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _onSendCode(BuildContext context) {
    if (!_allChecked) return;
    setState(() => _isSubmitting = true);
    context.read<JoinCircleCubit>().acceptContract(
      agreedToTerms: _agreedToTerms,
      agreedToInstallmentSchedule: _agreedToInstallments,
      agreedToLateFees: _agreedToLateFees,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JoinCircleCubit, JoinCircleState>(
      listener: (context, state) {
        if (state is JoinCircleContractAccepted) {
          setState(() => _isSubmitting = false);
          final cubit = context.read<JoinCircleCubit>();
          context.push(AppRoutes.joinOtpPath(widget.circleId), extra: cubit);
        }

        if (state is JoinCircleReservationExpired) {
          setState(() => _isSubmitting = false);
          _showExpiredDialog(context);
        }

        if (state is JoinCircleAcceptContractFailure) {
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
        final hasContractUrl = (cubit.contract?.downloadUrl ?? '').isNotEmpty;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ────────────────────────────────────
                  JoinFlowHeader(
                    title: 'مراجعة العقد',
                    onBack: () => context.pop(),
                  ),
                  SizedBox(height: 12.h),
                  const JoinStepIndicator(currentStep: 5),
                  SizedBox(height: 20.h),

                  // ── Body ──────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ── Contract card ──────────────────────
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 32.h,
                              horizontal: 20.w,
                            ),
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
                            child: Column(
                              children: [
                                Container(
                                  width: 68.w,
                                  height: 68.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F7F7),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Icon(
                                    Icons.description_outlined,
                                    size: 34.sp,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  'عقد الاشتراك في الجمعية',
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20.h),
                                OutlinedButton(
                                  onPressed: hasContractUrl
                                      ? _onViewContract
                                      : null,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: hasContractUrl
                                          ? AppColors.primary
                                          : AppColors.greyBut,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 28.w,
                                      vertical: 12.h,
                                    ),
                                  ),
                                  child: Text(
                                    'عرض العقد',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: hasContractUrl
                                          ? AppColors.primary
                                          : AppColors.textDisabled,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 28.h),

                          // ── Checkboxes ─────────────────────────
                          _CheckboxItem(
                            label: 'أوافق على فرض رسوم تأخير',
                            value: _agreedToLateFees,
                            onChanged: (v) =>
                                setState(() => _agreedToLateFees = v ?? false),
                          ),
                          SizedBox(height: 10.h),
                          _CheckboxItem(
                            label: 'أوافق على جدول التقسيط',
                            value: _agreedToInstallments,
                            onChanged: (v) => setState(
                              () => _agreedToInstallments = v ?? false,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _CheckboxItem(
                            label: 'أوافق على شروط الاستخدام وسياسة الخصوصية.',
                            value: _agreedToTerms,
                            onChanged: (v) =>
                                setState(() => _agreedToTerms = v ?? false),
                          ),

                          SizedBox(height: 24.h),

                          const JoinInfoBox(
                            message:
                                'بمتابعة هذه الخطوة فأنك تؤكد مراجعة العقد قبل اتمام عملية التحقق.',
                          ),

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),

                  // ── Bottom button ──────────────────────────────
                  JoinFlowBottomBar(
                    label: 'ارسل رمز التحقق',
                    enabled: _allChecked && !_isSubmitting,
                    isLoading: _isSubmitting,
                    onTap: () => _onSendCode(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showExpiredDialog(BuildContext context) {
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
            'انتهت صلاحية الحجز',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
          ),
          content: Text(
            'انتهت صلاحية حجزك. يمكنك إنشاء حجز جديد من شاشة المراجعة.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.pop(); // back to SubscriptionReviewView
              },
              child: Text(
                'إنشاء حجز جديد',
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

class _CheckboxItem extends StatelessWidget {
  const _CheckboxItem({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: value ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(5.r),
              border: Border.all(
                color: value ? AppColors.primary : AppColors.greyBut,
                width: 1.5,
              ),
            ),
            child: value
                ? Icon(Icons.check, size: 13.sp, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }
}
