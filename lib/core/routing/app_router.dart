import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jameya/core/animations/smart_animate_transition.dart';
import 'package:jameya/core/routing/routes.dart';
import 'package:jameya/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:jameya/features/onboarding/presentation/viewmodel/onboarding_cubit.dart';
import 'package:jameya/features/splash/view/splash_view.dart';

import '../../features/auth/presentation/views/phone_number_view.dart';

// Defines the app's navigation using GoRouter
abstract final class AppRouter {
  static final router = GoRouter(
    routes: [
      //* ── Splash ─────────────────────────────────────
      GoRoute(
        path: AppRoutes.kSplashView,
        builder: (context, state) => const SplashView(),
      ),

      //* ── Onboarding ──────────────────────────────────
      GoRoute(
        path: AppRoutes.kOnboardingView,
        pageBuilder: (context, state) => SmartAnimateTransition.buildPage(
          state: state,
          child: BlocProvider(
            create: (_) => OnboardingCubit(),
            child: const OnboardingView(),
          ),
        ),
      ),


//* --- Phone Number ---
   GoRoute(
  path: AppRoutes.kPhoneNumberView,
   pageBuilder: (context, state) {
   return _buildTransitionPage(
   state: state,
  child: const PhoneNumberView(),
  );
   },
  )
   ]);

  static _buildTransitionPage({required GoRouterState state, required PhoneNumberView child}) {}
}
