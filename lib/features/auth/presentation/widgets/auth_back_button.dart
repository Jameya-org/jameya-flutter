import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class AuthBackButton extends StatelessWidget {
  const AuthBackButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: 8.h,
          right: 1.w,
        ),
        child: IconButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: 20.r,
          icon: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.backgroundLight,
            size: 20.sp,
          ),
        ),
      ),
    );
  }
}