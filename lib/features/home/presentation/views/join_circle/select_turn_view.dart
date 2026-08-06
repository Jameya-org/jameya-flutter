import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/routes.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_text_styles.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../features/home/data/models/home_dashboard_model.dart';
import '../../cubit/join_circle_cubit.dart';
import '../../cubit/join_circle_state.dart';
import '../../widgets/join_flow_shared.dart';
import '../../widgets/join_step_indicator.dart';
import '../../widgets/turn_card.dart';
import 'eligibility_blocked_view.dart';

/// Step 2/7 — Select Turn.
///
/// Loads positions on mount (skips API if already loaded).
/// After a 409, force-refreshes the list automatically.
class SelectTurnView extends StatefulWidget {
  final String circleId;

  const SelectTurnView({super.key, required this.circleId});

  @override
  State<SelectTurnView> createState() => _SelectTurnViewState();
}

class _SelectTurnViewState extends State<SelectTurnView> {
  @override
  void initState() {
    super.initState();
    context.read<JoinCircleCubit>().loadPositions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JoinCircleCubit, JoinCircleState>(
      listener: (context, state) {
        if (state is JoinCircleIntentBlocked) {
          context.push(
            AppRoutes.eligibilityBlockedPath(widget.circleId),
            extra: {
              'reason': state.reason,
              'missingSteps': state.missingSteps,
            },
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<JoinCircleCubit>();
        final hasSelected = cubit.selectedPosition != null;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ────────────────────────────────────
                  JoinFlowHeader(
                    title: 'اختار الدور',
                    onBack: () => context.pop(),
                  ),
                  SizedBox(height: 12.h),
                  const JoinStepIndicator(currentStep: 2),
                  SizedBox(height: 20.h),

                  // ── Body ──────────────────────────────────────
                  Expanded(child: _buildBody(context, state, cubit)),

                  // ── Bottom button ──────────────────────────────
                  JoinFlowBottomBar(
                    label: 'التالي',
                    enabled: hasSelected,
                    onTap: () => context.push(
                      AppRoutes.paymentInfoPath(widget.circleId),
                      extra: cubit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    JoinCircleState state,
    JoinCircleCubit cubit,
  ) {
    if (state is JoinCirclePositionsLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state is JoinCirclePositionsError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded, size: 48.sp, color: AppColors.textHint),
              SizedBox(height: 16.h),
              Text(
                state.message,
                style: AppTextStyles.body.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              CustomButton(
                text: 'إعادة المحاولة',
                onPressed: () =>
                    context.read<JoinCircleCubit>().loadPositions(forceRefresh: true),
              ),
            ],
          ),
        ),
      );
    }

    final positions = cubit.positions;
    if (positions.isEmpty) return const SizedBox.shrink();

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
      itemCount: positions.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final pos = positions[index];
        final isSelected =
            cubit.selectedPosition?.position == pos.position;
        return TurnCard(
          position: pos,
          isSelected: isSelected,
          payoutDate: cubit.computePayoutDate(pos.position),
          onTap: pos.isAvailable
              ? () => cubit.selectPosition(pos)
              : null,
        );
      },
    );
  }
}
