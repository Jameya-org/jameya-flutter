import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jameya/core/routing/app_rotes.dart';
import 'package:jameya/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:jameya/features/splash/view/splash_view.dart';

// Defines the app's navigation using GoRouter
abstract final class AppRouter {
  // Wraps any page with a fade transition animation
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

  // The global router instance with all app routes
  static final router = GoRouter(
    routes: [
      //* --- Splash ---
      GoRoute(
        path: AppRoutes.kSplashView,
        builder: (context, state) => const SplashView(),
      ),
      //* --- Onboarding ---
      GoRoute(
        path: AppRoutes.kOnboardingView,
        pageBuilder: (context, state) {
          return _buildTransitionPage(
            state: state,
            child: const OnboardingView(),
          );
        },
      ),
    ],
  );
}
