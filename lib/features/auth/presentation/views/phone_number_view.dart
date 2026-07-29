import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../widgets/auth_background.dart';
import '../widgets/auth_back_button.dart';
import '../widgets/auth_title_section.dart';
import '../widgets/phone_number_field.dart';
import '../widgets/primary_button.dart';

class PhoneNumberView extends StatefulWidget {
  const PhoneNumberView({super.key});

  @override
  State<PhoneNumberView> createState() => _PhoneNumberViewState();
}

class _PhoneNumberViewState extends State<PhoneNumberView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Offset> _containerAnimation;
  late final Animation<double> _headerAnimation;
  late final Animation<double> _fieldAnimation;
  late final Animation<double> _buttonAnimation;

  final TextEditingController _phoneController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _containerAnimation =
        Tween<Offset>(
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

    _phoneController.addListener(() {
      setState(() {
        _isButtonEnabled = _phoneController.text.trim().length == 11;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              title: 'ادخل رقم تليفونك',
              subtitle:
              'الرقم ده هيكون رقم التواصل الأساسي معاك بعد ما تشترك معانا.',
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
              child: PhoneNumberField(
                controller: _phoneController,
                onChanged: (value) {
                  setState(() {
                    _isButtonEnabled = value.trim().length == 11;
                  });
                },
              ),
            ),

            const Spacer(),

            FadeTransition(
              opacity: _buttonAnimation,
              child: PrimaryButton(
                text: 'التالي',
                isEnabled: _isButtonEnabled,
                onPressed: _isButtonEnabled
                    ? () {
                  // TODO: Next Screen
                }
                    : null,
              ),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}