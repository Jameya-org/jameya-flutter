import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../../../../core/utils/assets.dart';
import '../cubit/circles_cubit.dart';
import '../cubit/circles_state.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/circle_card.dart';
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
        context.read<CirclesCubit>().loadAvailableCircles();
      }
    });
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<HomeCubit>().loadHomeDashboard(),
      context.read<CirclesCubit>().loadAvailableCircles(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Fixed greeting header ──
              const _HomeGreetingHeader(),

              // ── Scrollable body ──
              Expanded(
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
                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: _onRefresh,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 12.h),

                              // "ابدأ أول جمعية لك" card — always visible
                              EmptyCircleCard(
                                onBrowseCircles: () => context
                                    .push(AppRoutes.kAvailableCirclesView),
                              ),

                              SizedBox(height: 32.h),

                              // Section header
                              SectionHeader(
                                title: 'الجمعيات المتاحة',
                                actionLabel: 'عرض المزيد',
                                onActionTap: () => context
                                    .push(AppRoutes.kAvailableCirclesView),
                              ),

                              SizedBox(height: 14.h),

                              // Inline available circles from CirclesCubit
                              BlocBuilder<CirclesCubit, CirclesState>(
                                builder: (context, circlesState) {
                                  if (circlesState is CirclesLoading) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 24.h),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    );
                                  }
                                  if (circlesState is CirclesSuccess &&
                                      circlesState.circles.isNotEmpty) {
                                    final preview =
                                        circlesState.circles.take(5).toList();
                                    return Column(
                                      children: List.generate(
                                        preview.length,
                                        (i) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom: i < preview.length - 1
                                                ? 12.h
                                                : 0,
                                          ),
                                          child:
                                              CircleCard(circle: preview[i]),
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),

                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Greeting header — always visible above the scroll
// ─────────────────────────────────────────────

class _HomeGreetingHeader extends StatelessWidget {
  const _HomeGreetingHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Left: notification bell in light-teal circle ──
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F7F7),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Assets.iconsBell,
                    width: 22.w,
                    height: 22.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              // Orange notification dot
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  width: 9.w,
                  height: 9.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE87D3E),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          // ── Center: greeting text ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('👋', style: TextStyle(fontSize: 20.sp)),
                    SizedBox(width: 4.w),
                    Text(
                      'أهلاً بك',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontSize: 20.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'كل ما يخص جمعيتك في مكان واحد.',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textHint,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),

          // ── Right: user avatar ──
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.grey200,
            child: Text(
              '؟',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
