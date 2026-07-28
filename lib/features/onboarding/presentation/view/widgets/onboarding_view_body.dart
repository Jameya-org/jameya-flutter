import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jameya/core/animations/smart_animate_transition.dart';
import 'package:jameya/core/routing/routes.dart';
import 'package:jameya/features/onboarding/data/models/onboarding_model.dart';
import 'package:jameya/features/onboarding/presentation/view/widgets/onboarding_bottom_section.dart';
import 'package:jameya/features/onboarding/presentation/view/widgets/onboarding_page_item.dart';
import 'package:jameya/features/onboarding/presentation/view/widgets/onboarding_top_bar.dart';
import 'package:jameya/features/onboarding/presentation/viewmodel/onboarding_cubit.dart';

class OnboardingViewBody extends StatefulWidget {
  const OnboardingViewBody({super.key});

  @override
  State<OnboardingViewBody> createState() => _OnboardingViewBodyState();
}

class _OnboardingViewBodyState extends State<OnboardingViewBody> {
  late final PageController _pageController;
  late final List<OnboardingModel> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pages = OnboardingModel.getPages(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    final cubit = context.read<OnboardingCubit>();
    if (cubit.isLastPage) {
      cubit.completeOnboarding(context);
    } else {
      _pageController.nextPage(
        duration: SmartAnimateTransition.pageDuration,
        curve: SmartAnimateTransition.pageCurve,
      );
    }
  }

  void _onSkipPressed() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: SmartAnimateTransition.pageDuration,
      curve: SmartAnimateTransition.pageCurve,
    );
  }

  void _onBackPressed() {
    final cubit = context.read<OnboardingCubit>();
    if (cubit.currentIndex == 0) {
      context.go(AppRoutes.kSplashView);
    } else {
      _pageController.previousPage(
        duration: SmartAnimateTransition.pageDuration,
        curve: SmartAnimateTransition.pageCurve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLandscape = MediaQuery.of(context).size.height < 500;
    return SafeArea(
      child: Column(
        children: [
          // ── Top Bar (Skip & Page Indicator) ──────────
          OnboardingTopBar(
            totalPages: _pages.length,
            onSkipPressed: _onSkipPressed,
            onBackPressed: _onBackPressed,
          ),

          // ── Page View ────────────────────────────────
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: context.read<OnboardingCubit>().onPageChanged,
              itemBuilder: (context, index) =>
                  OnboardingPageItem(model: _pages[index]),
            ),
          ),

          SizedBox(height: isLandscape ? 4.h : 48.h),

          // ── Bottom Section (Dots + Button) ───────────
          OnboardingBottomSection(
            totalPages: _pages.length,
            onNextPressed: _onNextPressed,
          ),

          SizedBox(height: isLandscape ? 8.h : 74.h),
        ],
      ),
    );
  }
}
