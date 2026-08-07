abstract final class CacheKeys {
  const CacheKeys._();

  // Auth tokens
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';

  // App preferences
  static const onBoardingViewed = 'onBoardingViewed';
  static const languageCode = 'languageCode';

  // Persisted basic profile fields
  // NOTE: identity-specific fields (nationalId, birthDate, governorate, city,
  // streetAddress) are no longer cached locally — they are always fetched
  // fresh from GET /customers/kyc-status via KycProvider.
  static const email = 'profile_email';
  static const legalName = 'profile_legal_name';
  static const phone = 'profile_phone';
}
