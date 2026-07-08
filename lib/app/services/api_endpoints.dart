class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://192.168.1.10:5000';

  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String refresh = '/api/auth/refresh';
  static const String logout = '/api/auth/logout';
  static const String onboarding = '/api/members/onboarding';
  static const String profile = '/api/members/profile';
  static const String status = '/status';
}
