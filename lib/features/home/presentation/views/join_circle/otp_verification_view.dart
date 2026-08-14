import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../cubit/join_circle_cubit.dart';
import '../../cubit/join_circle_state.dart';
import '../../widgets/join_flow_shared.dart';
import '../../widgets/join_step_indicator.dart';

/// Step 6/7 — OTP Verification.
///
/// OTP was already sent by the backend when contract/accept succeeded.
/// This screen only calls [JoinCircleCubit.verifyOtp].
/// Resend = calls acceptContract again (re-triggers OTP send).
///
/// Error handling:
///  • invalid_otp → inline error, fields cleared
///  • otp_expired → inline error, resend enabled immediately
///  • network     → snackbar, button re-enabled
class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key, required this.circleId});
  final String circleId;

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  final TextEditingController _otpController = TextEditingController();
  final StreamController<ErrorAnimationType> _errorController =
      StreamController<ErrorAnimationType>();

  static const int _defaultResendSeconds = 60;
  late final int _resendSeconds;
  int _secondsRemaining = 0;
  bool _canResend = false;
  Timer? _resendTimer;

  bool _isOtpComplete = false;
  String? _inlineError;

  @override
  void initState() {
    super.initState();
    final expiresIn = context.read<JoinCircleCubit>().otpExpiresIn;
    _resendSeconds = expiresIn > 0 ? expiresIn : _defaultResendSeconds;
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() {
      _secondsRemaining = _resendSeconds;
      _canResend = false;
      _inlineError = null;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 0) {
        timer.cancel();
        if (mounted) setState(() => _canResend = true);
        return;
      }
      if (mounted) setState(() => _secondsRemaining--);
    });
  }

  void _enableResendImmediately() {
    _resendTimer?.cancel();
    if (mounted) {
      setState(() {
        _secondsRemaining = 0;
        _canResend = true;
      });
    }
  }

  void _onResend(BuildContext context) {
    _otpController.clear();
    _startResendTimer();
    context.read<JoinCircleCubit>().acceptContract(
      agreedToTerms: true,
      agreedToInstallmentSchedule: true,
      agreedToLateFees: true,
    );
  }

  void _verify(BuildContext context) {
    final otp = _otpController.text.trim();
    if (otp.length < 6) return;
    setState(() => _inlineError = null);
    context.read<JoinCircleCubit>().verifyOtp(otp);
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpController.dispose();
    _errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JoinCircleCubit, JoinCircleState>(
      listener: (context, state) {
        if (state is JoinCircleJoinComplete) {
          final cubit = context.read<JoinCircleCubit>();
          context.pushReplacement(
            AppRoutes.joinSuccessPath(widget.circleId),
            extra: cubit,
          );
        }

        if (state is JoinCircleOtpInvalid) {
          _errorController.add(ErrorAnimationType.shake);
          _otpController.clear();
          setState(() {
            _isOtpComplete = false;
            _inlineError = state.message;
          });
        }

        if (state is JoinCircleOtpExpired) {
          _errorController.add(ErrorAnimationType.shake);
          _otpController.clear();
          setState(() {
            _isOtpComplete = false;
            _inlineError = state.message;
          });
          _enableResendImmediately();
        }

        if (state is JoinCircleVerifyOtpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }

        if (state is JoinCircleContractAccepted) {
          _startResendTimer();
        }
      },
      builder: (context, state) {
        final isVerifying =
            state is JoinCircleVerifyingOtp ||
            state is JoinCircleAcceptingContract;

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
                    title: 'رمز التحقق',
                    onBack: () => context.pop(),
                  ),
                  SizedBox(height: 12.h),
                  const JoinStepIndicator(currentStep: 6),
                  SizedBox(height: 40.h),

                  // ── Body ──────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          Text(
                            'رمز التحقق',
                            style: AppTextStyles.subtitle.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'أدخل رمز التحقق المكون من 6 أرقام المُرسل إلى رقم هاتفك المسجل.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textHint,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 36.h),

                          // ── 6 OTP boxes ──────────────────────
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            controller: _otpController,
                            errorAnimationController: _errorController,
                            autoFocus: true,
                            keyboardType: TextInputType.number,
                            textStyle: AppTextStyles.body.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              fontSize: 20.sp,
                            ),
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10.r),
                              fieldHeight: 52.h,
                              fieldWidth: 46.w,
                              activeFillColor: AppColors.surface,
                              activeColor: AppColors.primary,
                              selectedColor: AppColors.primary,
                              selectedFillColor: const Color(0xFFE6F7F7),
                              inactiveFillColor: AppColors.surface,
                              inactiveColor: AppColors.grey200,
                              errorBorderColor: AppColors.error,
                            ),
                            enableActiveFill: true,
                            animationType: AnimationType.scale,
                            animationDuration: const Duration(
                              milliseconds: 150,
                            ),
                            onChanged: (val) {
                              setState(() {
                                _isOtpComplete = val.length == 6;
                                if (_inlineError != null && val.isNotEmpty) {
                                  _inlineError = null;
                                }
                              });
                            },
                            onCompleted: (_) => _verify(context),
                            beforeTextPaste: (text) {
                              return text != null &&
                                  text.length == 6 &&
                                  int.tryParse(text) != null;
                            },
                          ),

                          if (_inlineError != null) ...[
                            SizedBox(height: 8.h),
                            Text(
                              _inlineError!,
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],

                          SizedBox(height: 28.h),

                          // ── Resend section ───────────────────
                          Column(
                            children: [
                              Text(
                                'لم تستلم الرمز؟',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textHint,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              GestureDetector(
                                onTap: _canResend && !isVerifying
                                    ? () => _onResend(context)
                                    : null,
                                child: Text(
                                  _canResend
                                      ? 'إعادة الإرسال'
                                      : 'إعادة الإرسال ($_secondsRemainingث)',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: _canResend
                                        ? AppColors.primary
                                        : AppColors.textDisabled,
                                    fontWeight: FontWeight.w600,
                                    decoration: _canResend
                                        ? TextDecoration.underline
                                        : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),

                  // ── Bottom button ──────────────────────────────
                  JoinFlowBottomBar(
                    label: 'تأكيد',
                    enabled: _isOtpComplete && !isVerifying,
                    isLoading: isVerifying,
                    onTap: () => _verify(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
