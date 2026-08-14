import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
class CountryCodeWidget extends StatelessWidget {
  const CountryCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 12.w),

        Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.grey100,
          size: 18.sp,
        ),

        SizedBox(width: 8.w),

        const Text(
          '🇪🇬',
          style: TextStyle(fontSize: 20),
        ),

        SizedBox(width: 12.w),

        Container(
          width: 1,
          height: 24.h,
          color: AppColors.border,
        ),

        SizedBox(width: 12.w),

        Text(
          '+20',
          style: AppTextStyles.displayMedium,
        ),

        SizedBox(width: 12.w),
      ],
    );
  }
}