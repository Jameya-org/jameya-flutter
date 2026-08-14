import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Onboarding page title widget.
class OnboardingTitle extends StatelessWidget {
  final String title;

  const OnboardingTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF181818),
        fontFamily: 'Inter',
        height: 1.35,
        letterSpacing: -0.3,
      ),
    );
  }
}
