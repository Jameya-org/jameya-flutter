import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jameya/core/animations/smart_animate_transition.dart';
import 'package:jameya/core/routing/routes.dart';
import 'package:jameya/features/auth/presentation/views/otp_view.dart';
import 'package:jameya/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:jameya/features/onboarding/presentation/viewmodel/onboarding_cubit.dart';
import 'package:jameya/features/splash/view/splash_view.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/views/create_account_view.dart';
import '../../features/auth/presentation/views/email_view.dart';
import '../services/services_locator.dart';

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


//* --- Email ---
      GoRoute(
        path: AppRoutes.kEmailView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: const EmailView(),
          );
        },
      ),

//* --- OTP ---
      GoRoute(
        path: AppRoutes.kOtpView,
        builder: (context, state) {
          final email = state.extra as String;

          return OtpView(
            email: email,
          );
        },
      ),  GoRoute(
        path: AppRoutes.kCreateAccountView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: const CreateAccountView(),
          );
        },
      ),

   ]);

}
