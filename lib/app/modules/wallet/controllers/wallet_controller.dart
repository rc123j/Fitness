import 'package:get/get.dart';

class WalletController extends GetxController {
  // Balance Observables
  final fitPoints = 2450.obs;
  final fitPointsValue = 24.50.obs;
  final cashBalance = 45.60.obs;

  // Level & XP Details
  final currentLevel = "Gold".obs;
  final currentXP = 1250.obs;
  final nextLevelXP = 2000.obs;

  // Earnable Tasks List
  final earnTasks = <Map<String, dynamic>>[
    {"title": "Daily Check-in", "points": 20, "icon": "flame"},
    {"title": "Complete Workout", "points": 50, "icon": "dumbbell"},
    {"title": "Log a Meal", "points": 20, "icon": "bowl"},
    {"title": "Achieve Goal", "points": 100, "icon": "target"},
    {"title": "Refer a Friend", "points": 200, "icon": "users"},
  ].obs;

  // Redeemable Rewards List
  final rewards = <Map<String, dynamic>>[
    {
      "title": "Amazon Gift Card",
      "subtitle": "Amazon Gift Card",
      "points": 500,
      "brand": "amazon"
    },
    {
      "title": "20% Off",
      "subtitle": "Protein Supplements",
      "points": 750,
      "brand": "protein"
    },
    {
      "title": "Spotify Premium",
      "subtitle": "1 Month",
      "points": 600,
      "brand": "spotify"
    },
    {
      "title": "1 Month",
      "subtitle": "Free Diet Plan",
      "points": 1000,
      "brand": "diet"
    },
  ].obs;

  // Transactions History
  final transactions = <Map<String, dynamic>>[
    {
      "title": "Workout Completed",
      "desc": "Strength Training",
      "points": 50,
      "isAddition": true,
      "time": "Today, 8:30 AM",
      "icon": "workout"
    },
    {
      "title": "Referral Bonus",
      "desc": "Your friend joined NutriFit",
      "points": 200,
      "isAddition": true,
      "time": "Yesterday, 6:15 PM",
      "icon": "referral"
    },
    {
      "title": "Amazon Gift Card",
      "desc": "Redemption",
      "points": -500,
      "isAddition": false,
      "time": "12 May, 11:20 AM",
      "icon": "amazon"
    },
  ].obs;

  void redeemReward(int pointsCost) {
    if (fitPoints.value >= pointsCost) {
      fitPoints.value -= pointsCost;
      // Add transaction to the top of list
      transactions.insert(0, {
        "title": "Reward Redeemed",
        "desc": "Redemption success",
        "points": -pointsCost,
        "isAddition": false,
        "time": "Just now",
        "icon": "redeem"
      });
      Get.snackbar(
        "Success",
        "Reward successfully redeemed!",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Failed",
        "Insufficient FitPoints balance.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void checkIn() {
    fitPoints.value += 20;
    transactions.insert(0, {
      "title": "Daily Check-in",
      "desc": "Daily streak bonus",
      "points": 20,
      "isAddition": true,
      "time": "Just now",
      "icon": "flame"
    });
    Get.snackbar(
      "Checked In",
      "+20 FitPoints added!",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
