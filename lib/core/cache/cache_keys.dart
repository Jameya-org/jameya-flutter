abstract final class CacheKeys {
  const CacheKeys._();

  // Auth tokens
  static const accessToken = 'accessToken';
  static const refreshToken = 'refreshToken';

  // Persisted user profile fields
  static const email = 'profile_email';
  static const legalName = 'profile_legal_name';
  static const phone = 'profile_phone';
  static const nationalId = 'profile_national_id';
  static const birthDate = 'profile_birth_date';
  static const governorate = 'profile_governorate';
  static const city = 'profile_city';
  static const streetAddress = 'profile_street_address';
}
