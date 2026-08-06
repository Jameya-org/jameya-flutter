import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../animations/smart_animate_transition.dart';
import '../routing/routes.dart';
import '../../features/auth/presentation/views/create_account_view.dart';
import '../../features/auth/presentation/views/email_view.dart';
import '../../features/auth/presentation/views/otp_view.dart';
import '../../features/info/presentation/views/terms_and_conditions_view.dart';
import '../../features/kyc/presentation/views/kyc_verification_view.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/payment/presentation/views/add_card_view.dart';
import '../../features/payment/presentation/views/payment_methods_view.dart';
import '../../features/profile/presentation/views/profile_details_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/splash/views/splash_view.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.kSplashView,
        builder: (context, state) => const SplashView(),
      ),
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
      GoRoute(
        path: AppRoutes.kEmailView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: const EmailView(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kOtpView,
        builder: (context, state) {
          final email = state.extra as String;
          return OtpView(email: email);
        },
      ),
      GoRoute(
        path: AppRoutes.kCreateAccountView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: const CreateAccountView(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kProfileView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: const ProfileView(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kProfileDetailsView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: const ProfileDetailsView(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kPaymentMethodsView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: const PaymentMethodsView(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kAddCardView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: const AddCardView(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kKycVerificationView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: const KycVerificationView(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kTermsAndConditionsView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: const TermsAndConditionsView(),
          );
        },
      ),
    ],
  );
}
