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
import '../widgets/email_field.dart';
import '../widgets/primary_button.dart';

class EmailView extends StatefulWidget {
  const EmailView({super.key});

  @override
  State<EmailView> createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Offset> _containerAnimation;
  late final Animation<double> _headerAnimation;
  late final Animation<double> _fieldAnimation;
  late final Animation<double> _buttonAnimation;

  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _containerAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.45,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _headerAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.45,
        0.65,
        curve: Curves.easeIn,
      ),
    );

    _fieldAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.65,
        0.85,
        curve: Curves.easeIn,
      ),
    );

    _buttonAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.85,
        1.0,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();

    _emailController.addListener(() {
      final email = _emailController.text.trim();
      setState(() {
        _isButtonEnabled = RegExp(
          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(email);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RequestOtpSuccess) {
          context.push(
            AppRoutes.kOtpView,
            extra: _emailController.text.trim(),
          );
        }

        if (state is RequestOtpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        return AuthBackground(
          containerAnimation: _containerAnimation,
          header: FadeTransition(
            opacity: _headerAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 2.h),
                AuthBackButton(
                  onPressed: () => context.pop(),
                ),
                SizedBox(height: 4.h),
                const AuthTitleSection(
                  title: 'ادخل بريدك الإلكتروني',
                  subtitle:
                      'هيتم استخدام البريد الإلكتروني لإرسال كود التحقق وإدارة حسابك',
                ),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 32.h),
                FadeTransition(
                  opacity: _fieldAnimation,
                  child: EmailField(
                    controller: _emailController,
                  ),
                ),
                const Spacer(),
                FadeTransition(
                  opacity: _buttonAnimation,
                  child: PrimaryButton(
                    text: state is RequestOtpLoading
                        ? 'جاري الإرسال...'
                        : 'التالي',
                    isEnabled:
                        _isButtonEnabled && state is! RequestOtpLoading,
                    onPressed: _isButtonEnabled
                        ? () {
                            context.read<AuthCubit>().requestOtp(
                                  email: _emailController.text.trim(),
                                );
                          }
                        : null,
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }
}