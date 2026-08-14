import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    this.controller,
    this.onChanged,
    this.onCountryChanged,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCountryChanged;



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '*',
              style: AppTextStyles.body.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              'رقم الهاتف',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        SizedBox(height: 8.h),

        Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.backgroundLight,
            border: Border.all(
              color: AppColors.border,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              /// Country
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: CountryCodePicker(
                  initialSelection: 'EG',
                  favorite: const ['+20', 'EG'],
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                  padding: EdgeInsets.zero,
                  textStyle: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  onChanged: (country) {
                    onCountryChanged?.call(
                      country.dialCode ?? '+20',
                    );
                  },
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
                  textAlignVertical: TextAlignVertical.center,
                  style: AppTextStyles.body2,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: '01xxxxxxxxx',
                    hintStyle: AppTextStyles.body2.copyWith(
                      color: AppColors.textHint,
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