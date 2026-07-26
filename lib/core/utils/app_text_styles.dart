import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jameya/core/utils/app_colors.dart';

// Reusable text styles based on a consistent type scale
abstract final class AppTextStyles {
  const AppTextStyles._();

  // Default font used across all styles
  static const _fontFamily = 'Inter';

  static final appTitle = TextStyle(
    fontSize: 44.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    fontFamily: _fontFamily,
    height: 1.5,
    letterSpacing: -.02,
  );
  static final displayLarge = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    height: 1.5,
    letterSpacing: -.02,
  );

  static final displayMedium = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    height: 1.5,
    letterSpacing: -.02,
  );

  static final headline = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    height: 1.5,
    letterSpacing: -.02,
  );

  static final title = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    height: 1.5,
    letterSpacing: -.02,
  );

  static final subtitle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    fontFamily: _fontFamily,
    height: 1.5,
    letterSpacing: -.02,
  );

  static final body = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    height: 1.5,
    letterSpacing: -.02,
    color: AppColors.primary,
  );

  static final bodySmall = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    fontFamily: _fontFamily,
    height: 1.5,
    letterSpacing: -.02,
  );

  static final label = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    fontFamily: _fontFamily,
    height: 1.5,
    letterSpacing: -.02,
  );
}
