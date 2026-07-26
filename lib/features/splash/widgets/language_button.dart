import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jameya/core/localization/cubit/localization_cubit.dart';
import 'package:jameya/core/routing/app_rotes.dart';
import 'package:jameya/core/utils/app_colors.dart';
import 'package:jameya/core/utils/app_text_styles.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({
    super.key,
    required this.text,
    required this.localeCode,
  });

  final String text;
  final String localeCode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<LocaleCubit>().changeLanguage(localeCode);

        context.push(AppRoutes.kOnboardingView);
      },
      child: Container(
        height: 52.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Center(child: Text(text, style: AppTextStyles.body)),
      ),
    );
  }
}
