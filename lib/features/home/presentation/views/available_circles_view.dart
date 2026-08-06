import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_text_styles.dart';
import '../cubit/circles_cubit.dart';
import '../cubit/circles_state.dart';
import '../widgets/circle_card.dart';

/// Case 4: Full page listing all available circles.
class AvailableCirclesView extends StatefulWidget {
  const AvailableCirclesView({super.key});

  @override
  State<AvailableCirclesView> createState() => _AvailableCirclesViewState();
}

class _AvailableCirclesViewState extends State<AvailableCirclesView> {
  @override
  void initState() {
    super.initState();
    context.read<CirclesCubit>().loadAvailableCircles();
  }

  Future<void> _onRefresh() async {
    await context.read<CirclesCubit>().loadAvailableCircles();
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
                      'الجمعيات المتاحة',
                      style: AppTextStyles.subtitle.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Expanded(
                child: BlocBuilder<CirclesCubit, CirclesState>(
                  builder: (context, circlesState) {
                    final cubit = context.read<CirclesCubit>();
                    final circles = (circlesState is AvailableCirclesSuccess)
                        ? circlesState.circles
                        : cubit.availableCircles;

                    if (circlesState is AvailableCirclesLoading &&
                        circles.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (circlesState is CirclesFailure && circles.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              circlesState.message,
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

                    if (circles.isEmpty &&
                        circlesState is AvailableCirclesSuccess) {
                      return Center(
                        child: Text(
                          'لا توجد جمعيات متاحة',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textHint,
                          ),
                        ),
                      );
                    }

                    if (circles.isNotEmpty) {
                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: _onRefresh,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          itemCount: circles.length,
                          separatorBuilder: (_, _) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            return CircleCard(
                              circle: circles[index],
                            );
                          },
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
