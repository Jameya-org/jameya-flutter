import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class TermsCheckbox extends StatelessWidget {
  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),

        Expanded(
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: AppTextStyles.body.copyWith(
                color: AppColors.grey500,
              ),
              children: [
                const TextSpan(
                  text: 'أوافق على ',
                ),
                TextSpan(
                  text: 'شروط الاستخدام',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = onTermsTap,
                ),
                const TextSpan(
                  text: ' و ',
                ),
                TextSpan(
                  text: 'سياسة الخصوصية',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = onPrivacyTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}