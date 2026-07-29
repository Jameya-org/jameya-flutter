import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    this.controller,
    this.onChanged,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
            ),
            children: [
              const TextSpan(text: 'رقم الهاتف'),
              TextSpan(
                text: ' *',
                style: AppTextStyles.body.copyWith(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8.h),

        Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              /// Country
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    const Text(
                      '🇪🇬',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),

              Container(
                width: 1,
                height: 24.h,
                color: AppColors.border,
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.right,
                  onChanged: (value) {
                    print('Phone: $value');
                    onChanged?.call(value);
                  },
                  decoration: InputDecoration(
                    hintText: '01xxxxxxxxx',
                    hintStyle: AppTextStyles.body.copyWith(
                      color: AppColors.grey100,
                    ),
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}