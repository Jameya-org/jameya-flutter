import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '* ',
                style: AppTextStyles.displayMedium.copyWith(
                  color: Colors.red,
                ),
              ),
              TextSpan(
                text: 'الإيميل',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8.h),

        SizedBox(
          height: 56.h,
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.end,
            textDirection: TextDirection.ltr,
            style: AppTextStyles.body2,
            decoration: InputDecoration(
              hintText: 'example@gmail.com',
              hintStyle: AppTextStyles.body2.copyWith(
                color: AppColors.grey500,
              ),
              filled: true,
              fillColor: AppColors.backgroundLight,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.grey200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}