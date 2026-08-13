abstract final class AppRoutes {
  static const kSplashView = '/';
  static const kOnboardingView = '/onboarding';
  static const kEmailView = '/email';
  static const kOtpView = '/otp';
  static const kCreateAccountView = '/create';
  static const kProfileView = '/profile';
  static const kProfileDetailsView = '/personal-info';
  static const kPaymentMethodsView = '/payment-methods';
  static const kPaymentDetailsView = '/payment-details';
  static const kAddCardView = '/add-card';
  static const kKycVerificationView = '/kyc-verification';
  static const kTermsAndConditionsView = '/terms';

  // Home feature
  static const kHomeView = '/home';
  static const kProgressView = '/home/progress';
  static const kAvailableCirclesView = '/home/circles';
  static const kMyCirclesView = '/home/my-circles';
  static const kTransactionsView = '/home/transactions';

  // ── Join Circle Flow ──────────────────────────────────────
  // Route pattern constants (for GoRouter path matching)
  static const kCircleDetailView   = '/home/circles/:circleId/join/detail';
  static const kSelectTurnView     = '/home/circles/:circleId/join/turns';
  static const kPaymentInfoView    = '/home/circles/:circleId/join/payment';
  static const kSubscriptionReview = '/home/circles/:circleId/join/review';
  static const kContractReview     = '/home/circles/:circleId/join/contract';
  static const kJoinOtpView        = '/home/circles/:circleId/join/otp';
  static const kJoinSuccessView    = '/home/circles/:circleId/join/success';
  static const kEligibilityBlocked = '/home/circles/:circleId/join/blocked';

  // Navigation path helpers — use these when calling context.push()
  static String circleDetailPath(String id)     => '/home/circles/$id/join/detail';
  static String selectTurnPath(String id)       => '/home/circles/$id/join/turns';
  static String paymentInfoPath(String id)      => '/home/circles/$id/join/payment';
  static String subscriptionReviewPath(String id) => '/home/circles/$id/join/review';
  static String contractReviewPath(String id)   => '/home/circles/$id/join/contract';
  static String joinOtpPath(String id)          => '/home/circles/$id/join/otp';
  static String joinSuccessPath(String id)      => '/home/circles/$id/join/success';
  static String eligibilityBlockedPath(String id) => '/home/circles/$id/join/blocked';
}