import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jameya/core/routing/app_rotes.dart';
import 'package:jameya/features/splash/view/splash_view.dart';

abstract final class AppRouter {
  //* --- Global Transition ---
  static CustomTransitionPage<dynamic> _buildTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static final router = GoRouter(
    routes: [
      //* --- Splash ---
      GoRoute(
        path: AppRoutes.kSplashView,
        builder: (context, state) => const SplashView(),
      ),
      //* --- Onboarding ---
      // GoRoute(
      //   path: AppRoutes.kOnboardingView,
      //   pageBuilder: (context, state) {
      //     return _buildTransitionPage(
      //       state: state,
      //       child: const OnboardingView(),
      //     );
      //   },
      // ),
    ],
  );
}
