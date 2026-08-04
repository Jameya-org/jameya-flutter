import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class ResendCodeSection extends StatelessWidget {
  const ResendCodeSection({
    super.key,
    required this.remainingTime,
    required this.canResend,
    required this.onResend,
  });

  final String remainingTime;
  final bool canResend;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'الكود مبعتش؟',
          style: AppTextStyles.body.copyWith(
            color: AppColors.grey500,
          ),
        ),
        SizedBox(height: 8.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'ابعت كود تاني',
                style: AppTextStyles.body.copyWith(
                  color: canResend
                      ? AppColors.primary
                      : AppColors.grey500,
                  fontWeight: FontWeight.w600,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = canResend ? onResend : null,
              ),
              TextSpan(
                text: '   بعد $remainingTime',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}