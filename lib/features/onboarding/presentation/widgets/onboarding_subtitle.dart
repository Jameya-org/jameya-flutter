import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Onboarding page subtitle/description widget.
class OnboardingSubtitle extends StatelessWidget {
  final String subtitle;

  const OnboardingSubtitle({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16.sp,

        fontWeight: FontWeight.w400,
        color: const Color(0xFF3C4949),
        fontFamily: 'Inter',
        height: 1.7,
      ),
    );
  }
}
