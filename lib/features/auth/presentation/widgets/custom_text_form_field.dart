import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
        readOnly: readOnly,
        enabled: enabled,
        style: AppTextStyles.displayMedium,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.displayMedium.copyWith(
            color: AppColors.grey100,
          ),

          prefixIcon: prefix,
          suffixIcon: suffix,

          filled: true,
          fillColor: AppColors.backgroundLight,

          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),

          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(
            color: AppColors.primary,
            width: 1.5,
          ),
          errorBorder: _border(
            color: Colors.red,
          ),
          focusedErrorBorder: _border(
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border({
    Color? color,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: color ?? AppColors.border,
        width: width,
      ),
    );
  }
}