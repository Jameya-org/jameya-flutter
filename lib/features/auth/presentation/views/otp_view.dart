import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_title_section.dart';
import '../widgets/otp_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/resend_code_section.dart';

class OtpView extends StatefulWidget {
  const OtpView({super.key, required this.email});

  final String email;

  @override
  State<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends State<OtpView> {
  final TextEditingController _otpController = TextEditingController();

  bool _isButtonEnabled = false;
  Timer? _timer;

  int _secondsRemaining = 120;

  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _secondsRemaining = 120;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();

        setState(() {
          _canResend = true;
        });

        return;
      }

      setState(() {
        _secondsRemaining--;
      });
    });
  }

  String get formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(2, '0');

    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is VerifyOtpSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('تم التحقق بنجاح')));

          context.push(AppRoutes.kCreateAccountView);
        }

        if (state is VerifyOtpFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return AuthBackground(
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 2.h),
              AuthBackButton(onPressed: () => context.pop()),
              SizedBox(height: 4.h),
              AuthTitleSection(
                title: 'ادخل كود التأكيد',
                subtitle:
                    'اكتب الكود المكون من 6 أرقام واللي اتبعت علي الايميل بتاعك\n${widget.email}',
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final contentMinHeight = constraints.maxHeight - 56.h;

                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(top: 32.h, bottom: 24.h),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: contentMinHeight > 0 ? contentMinHeight : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            OtpField(
                              controller: _otpController,
                              onChanged: (value) {
                                setState(() {
                                  _isButtonEnabled = value.length == 6;
                                });
                              },
                              onCompleted: (value) {
                                // سيتم استخدامه مع الـ Backend لاحقًا
                              },
                            ),
                            SizedBox(height: 24.h),
                            ResendCodeSection(
                              remainingTime: formattedTime,
                              canResend: _canResend,
                              onResend: () {
                                _startTimer();

                                context.read<AuthCubit>().requestOtp(
                                  email: widget.email,
                                );
                              },
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                        PrimaryButton(
                          text: state is VerifyOtpLoading
                              ? 'جاري التحقق...'
                              : 'تأكيد',
                          isEnabled:
                              _isButtonEnabled && state is! VerifyOtpLoading,
                          onPressed: _isButtonEnabled
                              ? () {
                                  final otp = _otpController.text.trim();

                                  context.read<AuthCubit>().verifyOtp(
                                    email: widget.email,
                                    otp: otp,
                                  );
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
