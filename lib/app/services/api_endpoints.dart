class ApiEndpoints {
  ApiEndpoints._();

  // Set to true to connect to production server, false for local development
  static const bool isProduction = false;

  static const String baseUrl = isProduction
      ? 'https://api.fitwithdeveloper.com'
      : 'http://192.168.1.6:4017';

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
  static const String markMealComplete = '/api/diet-plans/meal-complete';
  static const String unmarkMealComplete = '/api/diet-plans/meal-uncomplete';

  // Progress, Steps & Hydration
  static const String logWater = '/api/progress/water';
  static const String todayWaterLog = '/api/progress/water/today';
  static const String progressLog = '/api/progress';
  static const String logSteps = '/api/progress/steps';
  static const String logWeight = '/api/progress/weight';
  static const String calorieHistory = '/api/diet-plans/logs/history';
}
