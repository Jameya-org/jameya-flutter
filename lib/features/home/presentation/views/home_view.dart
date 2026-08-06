import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../data/models/home_dashboard_model.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/active_circle_card.dart';
import '../widgets/circle_card.dart';
import '../widgets/empty_circle_card.dart';
import '../widgets/home_greeting_card.dart';
import '../widgets/progress_dots_indicator.dart';
import '../widgets/recent_activity_item.dart';
import '../widgets/section_header.dart';
import '../widgets/status_badge.dart';

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
                final dashboard = state.dashboard;
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
                        // Greeting
                        HomeGreetingCard(user: dashboard.user),
                        SizedBox(height: 24.h),

                        // Active circle OR empty state
                        if (dashboard.activeCircle != null)
                          _HasCircleBody(dashboard: dashboard)
                        else
                          _NoCircleBody(
                            dashboard: dashboard,
                          ),
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
// Case 1: User has an active circle
// ─────────────────────────────────────────────

class _HasCircleBody extends StatelessWidget {
  final HomeDashboardModel dashboard;

  const _HasCircleBody({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final circle = dashboard.activeCircle!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Active circle card
        ActiveCircleCard(circle: circle),
        SizedBox(height: 28.h),

        // Recent activities
        if (dashboard.recentActivities.isNotEmpty) ...[
          SectionHeader(title: 'اخر النشاطات'),
          SizedBox(height: 14.h),
          ...dashboard.recentActivities.map(
            (a) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: RecentActivityItem(activity: a),
            ),
          ),
          SizedBox(height: 14.h),
        ],

        // Progress section header
        SectionHeader(
          title: 'تقدم الجمعية',
          actionLabel: 'عرض المزيد',
          onActionTap: () => context.push(AppRoutes.kProgressView),
        ),
        SizedBox(height: 14.h),

        // Mini progress card for the active circle
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusBadge(status: circle.status),
                  Text(
                    'الدور الحالي',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                '${circle.currentTurn}/${circle.totalTurns}',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 12.h),
              ProgressDotsIndicator(
                currentTurn: circle.currentTurn,
                totalTurns: circle.totalTurns,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Case 3: User has no circles
// ─────────────────────────────────────────────

class _NoCircleBody extends StatelessWidget {
  final HomeDashboardModel dashboard;

  const _NoCircleBody({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Empty state card
        EmptyCircleCard(
          onBrowseCircles: () => context.push(AppRoutes.kAvailableCirclesView),
        ),
        SizedBox(height: 28.h),

        // Recommended circles
        if (dashboard.recommendedCircles.isNotEmpty) ...[
          SectionHeader(
            title: 'الجمعيات المتاحة',
            actionLabel: 'عرض المزيد',
            onActionTap: () =>
                context.push(AppRoutes.kAvailableCirclesView),
          ),
          SizedBox(height: 14.h),
          ...dashboard.recommendedCircles.map(
            (c) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: CircleCard(circle: c),
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ],
    );
  }
}
