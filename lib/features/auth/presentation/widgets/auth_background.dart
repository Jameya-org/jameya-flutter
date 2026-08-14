import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({
    super.key,
    required this.header,
    required this.child,
    this.containerAnimation,
  });

  final Widget header;
  final Widget child;
  final Animation<Offset>? containerAnimation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          /// Green Background
          const Positioned.fill(child: ColoredBox(color: AppColors.primary)),

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
            child: Builder(
              builder: (context) {
                Widget container = Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.r),
                      topRight: Radius.circular(32.r),
                    ),
                  ),
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    child: SafeArea(top: false, child: child),
                  ),
                );

                if (containerAnimation != null) {
                  container = SlideTransition(
                    position: containerAnimation!,
                    child: container,
                  );
                }

                return container;
              },
            ),
          ),
        ],
      ),
    );
  }
}
