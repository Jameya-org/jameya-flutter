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
import '../../features/splash/views/splash_view.dart';
import '../../features/home/presentation/views/main_layout_view.dart';
import '../../features/home/presentation/views/progress_view.dart';
import '../../features/home/presentation/views/available_circles_view.dart';
import '../../features/home/presentation/cubit/circles_cubit.dart';
import '../../features/home/presentation/cubit/join_circle_cubit.dart';
import '../../features/home/presentation/views/join_circle/circle_detail_view.dart';
import '../../features/home/presentation/views/join_circle/select_turn_view.dart';
import '../../features/home/presentation/views/join_circle/payment_info_view.dart';
import '../../features/home/presentation/views/join_circle/subscription_review_view.dart';
import '../../features/home/presentation/views/join_circle/contract_review_view.dart';
import '../../features/home/presentation/views/join_circle/otp_verification_view.dart';
import '../../features/home/presentation/views/join_circle/join_success_view.dart';
import '../../features/home/presentation/views/join_circle/eligibility_blocked_view.dart';
import '../services/services_locator.dart';

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
          final email = state.extra is String ? state.extra as String : '';
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
            child: const MainLayoutView(initialIndex: 3),
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

      // ── Home Feature ──────────────────────────────────────────
      GoRoute(
        path: AppRoutes.kHomeView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: const MainLayoutView(initialIndex: 0),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kProgressView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: BlocProvider(
              create: (_) => getIt<CirclesCubit>(),
              child: const ProgressView(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kAvailableCirclesView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: BlocProvider(
              create: (_) => getIt<CirclesCubit>(),
              child: const AvailableCirclesView(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kMyCirclesView,
        pageBuilder: (context, state) {
          return SmartAnimateTransition.buildPage(
            state: state,
            child: const MainLayoutView(initialIndex: 1),
          );
        },
      ),

      // ── Join Circle Flow ──────────────────────────────────────
      // Each screen receives the shared JoinCircleCubit via state.extra.
      // The cubit is created once at the entry point (AvailableCirclesView)
      // and passed forward — preserving all state across Back navigation.

      GoRoute(
        path: AppRoutes.kCircleDetailView,
        pageBuilder: (context, state) {
          final circleId = state.pathParameters['circleId']!;
          final cubit = _joinCubit(state);
          return SmartAnimateTransition.buildPage(
            state: state,
            child: BlocProvider.value(
              value: cubit,
              child: CircleDetailView(circleId: circleId),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kSelectTurnView,
        pageBuilder: (context, state) {
          final circleId = state.pathParameters['circleId']!;
          final cubit = _joinCubit(state);
          return SmartAnimateTransition.buildPage(
            state: state,
            child: BlocProvider.value(
              value: cubit,
              child: SelectTurnView(circleId: circleId),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kPaymentInfoView,
        pageBuilder: (context, state) {
          final circleId = state.pathParameters['circleId']!;
          final cubit = _joinCubit(state);
          return SmartAnimateTransition.buildPage(
            state: state,
            child: BlocProvider.value(
              value: cubit,
              child: PaymentInfoView(circleId: circleId),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kSubscriptionReview,
        pageBuilder: (context, state) {
          final circleId = state.pathParameters['circleId']!;
          final cubit = _joinCubit(state);
          return SmartAnimateTransition.buildPage(
            state: state,
            child: BlocProvider.value(
              value: cubit,
              child: SubscriptionReviewView(circleId: circleId),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kContractReview,
        pageBuilder: (context, state) {
          final circleId = state.pathParameters['circleId']!;
          final cubit = _joinCubit(state);
          return SmartAnimateTransition.buildPage(
            state: state,
            child: BlocProvider.value(
              value: cubit,
              child: ContractReviewView(circleId: circleId),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kJoinOtpView,
        pageBuilder: (context, state) {
          final circleId = state.pathParameters['circleId']!;
          final cubit = _joinCubit(state);
          return SmartAnimateTransition.buildPage(
            state: state,
            child: BlocProvider.value(
              value: cubit,
              child: OtpVerificationView(circleId: circleId),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kJoinSuccessView,
        pageBuilder: (context, state) {
          final circleId = state.pathParameters['circleId']!;
          final cubit = _joinCubit(state);
          return SmartAnimateTransition.buildPage(
            state: state,
            child: BlocProvider.value(
              value: cubit,
              child: JoinSuccessView(circleId: circleId),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.kEligibilityBlocked,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final reason = extra is Map ? (extra['reason'] as String?) ?? '' : '';
          final missingSteps = extra is Map
              ? (extra['missingSteps'] as List?)?.cast<String>() ?? []
              : <String>[];
          return SmartAnimateTransition.buildPage(
            state: state,
            child: EligibilityBlockedView(
              reason: reason,
              missingSteps: missingSteps,
            ),
          );
        },
      ),
    ],
  );

  /// Returns the [JoinCircleCubit] carried via `state.extra`, or a fresh
  /// instance when the flow is entered through a deep link / hot restart.
  static JoinCircleCubit _joinCubit(GoRouterState state) {
    final extra = state.extra;
    if (extra is JoinCircleCubit) return extra;
    return getIt<JoinCircleCubit>();
  }
}
