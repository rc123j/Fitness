import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main() {
  test('parsing test', () {
    String jsonStr = '''
    {
      "activation_id": 2,
      "diet_plan": {
        "diet_plan_meals": [
          {
            "id": 155,
            "meal_id": 5,
            "meal_type": { "name": "Dinner" },
            "foods": [
              {
                "calories": "0.00",
                "food_details": { "food_name": "Rice" }
              }
            ]
          }
        ]
      }
    }
    ''';
    
    final planResData = jsonDecode(jsonStr);
    final List mealsList = planResData['diet_plan']?['diet_plan_meals'] ?? [];
    List tempMeals = mealsList;
    
    final List<Map<String, dynamic>> tempHomeMeals = [];
    for (var meal in tempMeals) {
      final mealTypeName = meal['meal_type']?['name'] ?? 'Meal';
      final List foods = meal['foods'] ?? [];
      final String foodDesc = foods.map((f) => f['food_details']?['food_name'] ?? '').join(', ');

      double protein = 0.0;
      double carbs = 0.0;
      double fat = 0.0;
      double calories = 0.0;

      for (var f in foods) {
        calories += double.tryParse(f['calories']?.toString() ?? '0') ?? 0;
        protein += double.tryParse(f['protein']?.toString() ?? '0') ?? 0;
        carbs += double.tryParse(f['carbs']?.toString() ?? '0') ?? 0;
        fat += double.tryParse(f['fat']?.toString() ?? '0') ?? 0;
      }

      final int mealId = int.tryParse(meal['meal_id']?.toString() ?? '') ?? 1;

      tempHomeMeals.add({
        "meal_id": mealId,
        "title": mealTypeName,
        "desc": foodDesc.isNotEmpty ? foodDesc : "No foods assigned",
        "kcal": "\${calories.toInt()} kcal",
        "macros": "\${protein.toInt()}P • \${carbs.toInt()}C • \${fat.toInt()}F",
        "tag": "Pending",
      });
    }
    tempHomeMeals.sort((a, b) => (a['meal_id'] as int).compareTo(b['meal_id'] as int));
    print(tempHomeMeals);
  });
}
