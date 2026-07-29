import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({
    super.key,
    required this.header,
    required this.child,
    required this.containerAnimation,
  });

  final Widget header;
  final Widget child;
  final Animation<Offset> containerAnimation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          /// Green Background
          Positioned.fill(
            child: ColoredBox(
              color: AppColors.primary,
            ),
          ),

          /// Header
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: header,
            ),
          ),

          /// White Container
          Positioned.fill(
            top: 230.h,
            child: SlideTransition(
              position: containerAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}