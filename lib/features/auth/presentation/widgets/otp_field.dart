import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class OtpField extends StatelessWidget {
  const OtpField({
    super.key,
    required this.controller,
    this.onCompleted,
    this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      controller: controller,
      length: 6,
      keyboardType: TextInputType.number,
      animationType: AnimationType.none,
      autoDisposeControllers: false,
      cursorColor: AppColors.primary,

      onChanged: onChanged ?? (_) {},
      onCompleted: onCompleted,

      textStyle: AppTextStyles.subtitle.copyWith(
        color: AppColors.primary,
      ),

      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12.r),

        fieldHeight: 56.h,
        fieldWidth: 48.w,

        activeFillColor: AppColors.greyBut,
        selectedFillColor: AppColors.greyBut,
        inactiveFillColor: AppColors.greyBut,


        activeColor: AppColors.greyBut,
        inactiveColor: AppColors.greyBut,
        selectedColor: AppColors.primary,
      ),

      enableActiveFill: true,
    );
  }
}