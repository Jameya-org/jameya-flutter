import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../cubit/join_circle_cubit.dart';

/// Step 7/7 — Join Success.
///
/// All navigation is replaced/reset back to home.
/// Contract download opens the PDF URL in the system browser.
class JoinSuccessView extends StatelessWidget {
  const JoinSuccessView({super.key, required this.circleId});
  final String circleId;

  Future<void> _downloadContract(JoinCircleCubit cubit) async {
    final downloadUrl = cubit.contract?.downloadUrl ?? '';
    if (downloadUrl.isEmpty) return;

    final fullUrl = downloadUrl.startsWith('http')
        ? downloadUrl
        : 'https://jameya-backend.onrender.com$downloadUrl';

    final uri = Uri.parse(fullUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<JoinCircleCubit>();
    final hasContract = (cubit.contract?.downloadUrl ?? '').isNotEmpty;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // ── Success icon ──────────────────────────────────
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) =>
                      Transform.scale(scale: value, child: child),
                  child: Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F7F7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 58.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                SizedBox(height: 28.h),

                // ── Title ─────────────────────────────────────────
                Text(
                  'تم الاشتراك بنجاح',
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 22.sp,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.h),

                // ── Subtitle ──────────────────────────────────────
                Text(
                  'لقد انضممت بنجاح إلى الجمعية.\nيمكنك متابعة تقدمها من الصفحة الرئيسية.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 2),

                // ── Download contract button ───────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton.icon(
                    onPressed: hasContract
                        ? () => _downloadContract(cubit)
                        : null,
                    icon: Icon(
                      Icons.download_rounded,
                      size: 20.sp,
                      color: hasContract
                          ? Colors.white
                          : AppColors.textDisabled,
                    ),
                    label: Text(
                      'تحميل العقد',
                      style: AppTextStyles.body.copyWith(
                        color: hasContract
                            ? Colors.white
                            : AppColors.textDisabled,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasContract
                          ? AppColors.primary
                          : AppColors.greyBut,
                      disabledBackgroundColor: AppColors.greyBut,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 14.h),

                // ── Back to home button ────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: OutlinedButton(
                    onPressed: () => context.go(AppRoutes.kHomeView),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      'العودة للرئيسية',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
