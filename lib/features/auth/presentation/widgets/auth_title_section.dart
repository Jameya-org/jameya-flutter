import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jameya/core/utils/app_colors.dart';

import '../../../../core/utils/app_text_styles.dart';

class AuthTitleSection extends StatelessWidget {
  const AuthTitleSection({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.right,
          style: AppTextStyles.headline.copyWith(
            color: AppColors.background,
          ),
        ),

        SizedBox(height: 8.h),

        Text(
          subtitle,
          textAlign: TextAlign.right,
          style: AppTextStyles.body.copyWith(
            color: AppColors.background,
            height: 1,

          ),
        ),

      ],
    );
  }
}