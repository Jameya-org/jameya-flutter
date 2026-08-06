import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../data/models/home_dashboard_model.dart';

/// Top greeting card shown on the home screen.
/// Shows notification bell, greeting text, and user avatar (initials fallback).
/// Accepts [HomeUserModel] from the /customers/profile endpoint.
class HomeGreetingCard extends StatelessWidget {
  final HomeUserModel user;

  const HomeGreetingCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: notification bell
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  Assets.iconsBell,
                  width: 22.w,
                  height: 22.w,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            // Orange notification dot
            Positioned(
              top: 2,
              left: 2,
              child: Container(
                width: 10.w,
                height: 10.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFE87D3E),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),

        // Center: greeting text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '👋',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'صباح الخير، ${user.legalName}',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                'كل ما يخص جمعيتك في مكان واحد.',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),

        // Right: user avatar — initials fallback (no avatar URL from API)
        CircleAvatar(
          radius: 22.r,
          backgroundColor: AppColors.grey200,
          child: Text(
            user.legalName.isNotEmpty
                ? user.legalName[0].toUpperCase()
                : '؟',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
