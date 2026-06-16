import 'package:get/get.dart';

class MealController extends GetxController {
  final selectedDate = "Today, 15 May".obs;
  
  // Progress states
  final currentCalories = 2100.obs;
  final targetCalories = 2300.obs;
  final currentWater = 2.1.obs;
  final targetWater = 3.0.obs;
  
  // Macros
  final targetProtein = 145.obs;
  final targetCarbs = 210.obs;
  final targetFat = 65.obs;

  // Meal states
  final isBreakfastCompleted = true.obs;
  final isLunchCompleted = false.obs;
  final isSnacksCompleted = false.obs;
  final isDinnerCompleted = false.obs;

  void toggleMealCompletion(String mealType) {
    switch (mealType) {
      case "Breakfast":
        isBreakfastCompleted.value = !isBreakfastCompleted.value;
        break;
      case "Lunch":
        isLunchCompleted.value = !isLunchCompleted.value;
        break;
      case "Snacks":
        isSnacksCompleted.value = !isSnacksCompleted.value;
        break;
      case "Dinner":
        isDinnerCompleted.value = !isDinnerCompleted.value;
        break;
    }
  }

  void addWater(double amount) {
    if (currentWater.value + amount <= targetWater.value) {
      currentWater.value += amount;
    } else {
      currentWater.value = targetWater.value;
    }
  }

  void resetWater() {
    currentWater.value = 0.0;
  }
}
