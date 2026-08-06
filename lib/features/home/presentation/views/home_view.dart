import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/empty_circle_card.dart';
import '../widgets/section_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeCubit>().loadHomeDashboard();
      }
    });
  }

  Future<void> _onRefresh() async {
    await context.read<HomeCubit>().loadHomeDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              }

              if (state is HomeFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: _onRefresh,
                        child: Text(
                          'إعادة المحاولة',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is HomeSuccess) {
                final eligibility = state.eligibility;
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Greeting header (static — profile loaded separately)
                        _HomeGreetingHeader(),
                        SizedBox(height: 24.h),

                        // Eligibility / onboarding state
                        if (!eligibility.eligible)
                          _EligibilityBanner(
                            reason: eligibility.reason,
                            missingSteps: eligibility.missingSteps,
                          ),

                        SizedBox(height: 28.h),

                        // Available circles section
                        SectionHeader(
                          title: 'الجمعيات المتاحة',
                          actionLabel: 'عرض المزيد',
                          onActionTap: () =>
                              context.push(AppRoutes.kAvailableCirclesView),
                        ),
                        SizedBox(height: 14.h),

                        // Show empty state — circles are loaded separately
                        // from /customer/circles in AvailableCirclesView
                        EmptyCircleCard(
                          onBrowseCircles: () =>
                              context.push(AppRoutes.kAvailableCirclesView),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Static greeting header (no backend user data from home endpoint)
// ─────────────────────────────────────────────

class _HomeGreetingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Notification bell placeholder
        Container(
          width: 44.w,
          height: 44.w,
          decoration: const BoxDecoration(
            color: AppColors.grey100,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textPrimary,
          ),
        ),

        // Greeting text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('👋', style: TextStyle(fontSize: 18.sp)),
                  SizedBox(width: 4.w),
                  Text(
                    'أهلاً بك',
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

        // Avatar fallback — default icon
        CircleAvatar(
          radius: 22.r,
          backgroundColor: AppColors.grey200,
          child: Text(
            '؟',
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

// ─────────────────────────────────────────────
// Eligibility banner shown when user is not yet eligible
// ─────────────────────────────────────────────

class _EligibilityBanner extends StatelessWidget {
  final String reason;
  final List<String> missingSteps;

  const _EligibilityBanner({
    required this.reason,
    required this.missingSteps,
  });

  String _translateStep(String step) {
    switch (step) {
      case 'identity_verification':
        return 'التحقق من الهوية';
      case 'proof_of_income':
        return 'إثبات الدخل';
      case 'eligibility_decision':
        return 'قرار الأهلية';
      default:
        return step;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE87D3E).withValues(alpha: 0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'الحساب غير مؤهل بعد',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(width: 8.w),
              const Icon(
                Icons.info_outline_rounded,
                color: Color(0xFFE87D3E),
                size: 20,
              ),
            ],
          ),
          if (missingSteps.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              'الخطوات المطلوبة:',
              style: AppTextStyles.label.copyWith(color: AppColors.textHint),
            ),
            SizedBox(height: 6.h),
            ...missingSteps.map(
              (step) => Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _translateStep(step),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    const Icon(
                      Icons.radio_button_unchecked,
                      size: 14,
                      color: Color(0xFFE87D3E),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
