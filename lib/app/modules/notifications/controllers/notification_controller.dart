import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NotificationController extends GetxController {
  // Mock Notifications Database
  final notificationsList = <Map<String, dynamic>>[
    {
      "id": 1,
      "title": "Workout Streak! 🔥",
      "body": "Congratulations! You completed 5 workouts in a row. Keep up the high compliance!",
      "timestamp": "10 mins ago",
      "category": "Workouts",
      "isRead": false.obs,
    },
    {
      "id": 2,
      "title": "New Meal Plan Unlocked 🥗",
      "body": "Your personalized keto lunch plan has been updated by coach David. Tap to view macro targets.",
      "timestamp": "2 hours ago",
      "category": "Nutrition",
      "isRead": false.obs,
    },
    {
      "id": 3,
      "title": "New Comment in Social Room 💬",
      "body": "Marcus commented: 'Incredible progress! What was your macro split?'",
      "timestamp": "4 hours ago",
      "category": "Social",
      "isRead": true.obs,
    },
    {
      "id": 4,
      "title": "Family Tier Discount ⚡",
      "body": "Welcome to Level 2! Additional family profile activations are now 20% off.",
      "timestamp": "Yesterday",
      "category": "Alerts",
      "isRead": false.obs,
    },
    {
      "id": 5,
      "title": "Hydration Target Met 💧",
      "body": "Excellent job! You hit your target of 3.5L of water intake today.",
      "timestamp": "Yesterday",
      "category": "Nutrition",
      "isRead": true.obs,
    },
    {
      "id": 6,
      "title": "Leg Day Prep tomorrow 🏋️",
      "body": "Reminder: Prepare your gym bag and pre-workout supplement. Scheduled for 7:00 AM.",
      "timestamp": "2 days ago",
      "category": "Workouts",
      "isRead": true.obs,
    },
  ].obs;

  // Selected Filter Category
  final selectedFilter = "All".obs;

  // Filters list
  final filtersList = ["All", "Alerts", "Workouts", "Nutrition", "Social"];

  // Filtered getter
  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter.value == "All") {
      return notificationsList;
    }
    return notificationsList.where((n) => n["category"] == selectedFilter.value).toList();
  }

  // Count of unread notifications
  int get unreadCount => notificationsList.where((n) => !(n["isRead"] as RxBool).value).length;

  // Mark single as read
  void markAsRead(int id) {
    final index = notificationsList.indexWhere((n) => n["id"] == id);
    if (index != -1) {
      (notificationsList[index]["isRead"] as RxBool).value = true;
      notificationsList.refresh();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    for (var item in notificationsList) {
      (item["isRead"] as RxBool).value = true;
    }
    notificationsList.refresh();
    Get.snackbar(
      "Read Status",
      "All notifications marked as read.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff0B0817).withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  // Delete notification
  void deleteNotification(int id) {
    final index = notificationsList.indexWhere((n) => n["id"] == id);
    if (index != -1) {
      notificationsList.removeAt(index);
      notificationsList.refresh();
    }
  }

  // Clear all notifications
  void clearAll() {
    notificationsList.clear();
    notificationsList.refresh();
    Get.snackbar(
      "Cleared",
      "Notifications history cleared.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff0B0817).withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
