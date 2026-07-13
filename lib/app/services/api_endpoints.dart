class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://192.168.1.8:5000';

  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String refresh = '/api/auth/refresh';
  static const String logout = '/api/auth/logout';
  static const String onboarding = '/api/members/onboarding';
  static const String profile = '/api/members/profile';
  static const String status = '/status';

  // Diet & Meal logs
  static const String currentDietPlan = '/api/diet-plans/current';
  static const String logMeal = '/api/diet-plans/logs';
  static const String todayNutritionLog = '/api/diet-plans/logs/today';

  // Progress, Steps & Hydration
  static const String logWater = '/api/progress/water';
  static const String todayWaterLog = '/api/progress/water/today';
  static const String progressLog = '/api/progress';
  static const String logSteps = '/api/progress/steps';
  static const String logWeight = '/api/progress/weight';
}
