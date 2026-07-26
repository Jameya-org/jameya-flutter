// Keys used to read/write data in SharedPreferences and SecureStorage
abstract class CacheKey {
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';
  static const String userDataKey = 'userDataKey';
  static const String id = 'id';
  static const String onBoardingViewed = 'onBoardingViewed';

  static const String isLoggedIn = 'isLoggedIn';

  static const String languageCode = 'languageCode';
}
