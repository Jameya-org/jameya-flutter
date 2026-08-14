import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/assets.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                iconPath: Assets.iconsUser,
                label: 'حسابي',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavBarItem(
                iconPath: Assets.iconsMoney,
                label: 'سجل التعاملات',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavBarItem(
                iconPath: Assets.iconsRefresh,
                label: 'جمعياتي',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavBarItem(
                iconPath: Assets.iconsHome,
                label: 'الرئيسية',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : AppColors.textHint;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24.w,
              height: 24.w,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            SizedBox(height: 5.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.label.copyWith(
                color: color,
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
