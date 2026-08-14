import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import 'custom_text_form_field.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    this.requiredField = true,
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
    this.onTap,
  });

  final String label;
  final bool requiredField;

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
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (requiredField)
              Text(
                ' *',
                style: AppTextStyles.body.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),

            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        SizedBox(height: 8.h),

        CustomTextFormField(
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          prefix: prefix,
          suffix: suffix,
          obscureText: obscureText,
          readOnly: readOnly,
          enabled: enabled,
          onTap: onTap,
        ),
      ],
    );
  }
}