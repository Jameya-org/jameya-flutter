import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../cubit/circles_cubit.dart';
import '../cubit/circles_state.dart';
import '../widgets/circle_card.dart';

/// Case 5: My Circles page with two tabs — Available (ACTIVE) and Finished (FINISHED).
class MyCirclesView extends StatefulWidget {
  const MyCirclesView({super.key});

  @override
  State<MyCirclesView> createState() => _MyCirclesViewState();
}

class _MyCirclesViewState extends State<MyCirclesView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CirclesCubit>().loadMyCircles();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<CirclesCubit>().loadMyCircles();
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
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 16.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(
                        Icons.chevron_right,
                        color: AppColors.primary,
                        size: 28.sp,
                      ),
                    ),
                    Text(
                      'جمعياتي',
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Tab bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelStyle: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                    ),
                    unselectedLabelColor: AppColors.textHint,
                    tabs: const [
                      Tab(text: 'متاح للانضمام'),
                      Tab(text: 'مكتملة'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // Tab views
              Expanded(
                child: BlocBuilder<CirclesCubit, CirclesState>(
                  builder: (context, state) {
                    if (state is CirclesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (state is CirclesFailure) {
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

                    if (state is CirclesSuccess) {
                      final active = state.circles
                          .where((c) => c.status.toUpperCase() == 'ACTIVE')
                          .toList();
                      final finished = state.circles
                          .where(
                            (c) => c.status.toUpperCase() == 'FINISHED',
                          )
                          .toList();

                      return TabBarView(
                        controller: _tabController,
                        children: [
                          // Tab 1: Active / Available
                          RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: _onRefresh,
                            child: active.isEmpty
                                ? ListView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    children: [
                                      SizedBox(height: 80.h),
                                      Center(
                                        child: Text(
                                          'لا توجد جمعيات نشطة',
                                          style: AppTextStyles.body.copyWith(
                                            color: AppColors.textHint,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView.separated(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 4.h,
                                    ),
                                    itemCount: active.length,
                                    separatorBuilder: (_, _) =>
                                        SizedBox(height: 12.h),
                                    itemBuilder: (context, index) =>
                                        CircleCard(circle: active[index]),
                                  ),
                          ),

                          // Tab 2: Finished
                          RefreshIndicator(
                            color: AppColors.primary,
                            onRefresh: _onRefresh,
                            child: finished.isEmpty
                                ? ListView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    children: [
                                      SizedBox(height: 80.h),
                                      Center(
                                        child: Text(
                                          'لا توجد جمعيات منتهية',
                                          style: AppTextStyles.body.copyWith(
                                            color: AppColors.textHint,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView.separated(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 4.h,
                                    ),
                                    itemCount: finished.length,
                                    separatorBuilder: (_, _) =>
                                        SizedBox(height: 12.h),
                                    itemBuilder: (context, index) =>
                                        CircleCard(circle: finished[index]),
                                  ),
                          ),
                        ],
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
