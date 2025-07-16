class AppConstants {
  // API Base URLs
  static const String baseUrl = 'https://api.analyticinvest.com';
  static const String apiVersion = '/v1';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String isFirstTimeKey = 'is_first_time';

  // App Constants
  static const String appName = 'Analytic Invest';
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Error Messages
  static const String noInternetMessage = 'No internet connection';
  static const String serverErrorMessage = 'Server error occurred';
  static const String unknownErrorMessage = 'Unknown error occurred';
  static const String cacheErrorMessage = 'Cache error occurred';
}
