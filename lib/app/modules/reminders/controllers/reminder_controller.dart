import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ReminderController extends GetxController {
  // A simple representation of a Reminder
  final remindersList = <Map<String, dynamic>>[
    {
      "id": 1,
      "name": "Breakfast Nutrition",
      "type": "Meal",
      "time": "08:30 AM",
      "days": ["Everyday"],
      "isEnabled": true.obs,
      "snoozeDuration": 10,
    },
    {
      "id": 2,
      "name": "Hydration Spike",
      "type": "Water",
      "time": "11:00 AM",
      "days": ["Everyday"],
      "isEnabled": true.obs,
      "snoozeDuration": 5,
    },
    {
      "id": 3,
      "name": "Omega-3 & Multivitamin",
      "type": "Supplement",
      "time": "01:30 PM",
      "days": ["Mon", "Tue", "Wed", "Thu", "Fri"],
      "isEnabled": true.obs,
      "snoozeDuration": 15,
    },
    {
      "id": 4,
      "name": "Weekly Weight Check",
      "type": "Weight Check",
      "time": "07:00 AM",
      "days": ["Sat", "Sun"],
      "isEnabled": false.obs,
      "snoozeDuration": 10,
    },
    {
      "id": 5,
      "name": "Progress Body Scan",
      "type": "Progress Upload",
      "time": "09:00 PM",
      "days": ["Sun"],
      "isEnabled": true.obs,
      "snoozeDuration": 30,
    },
  ].obs;

  // Selected Category filter
  final activeFilter = "All".obs;

  // Categories list
  final categories = ["All", "Meal", "Water", "Supplement", "Weight Check", "Progress Upload"];

  // Filtered Reminders
  List<Map<String, dynamic>> get filteredReminders {
    if (activeFilter.value == "All") {
      return remindersList;
    }
    return remindersList.where((r) => r["type"] == activeFilter.value).toList();
  }

  // Toggle reminder state
  void toggleReminder(int id, bool value) {
    final index = remindersList.indexWhere((r) => r["id"] == id);
    if (index != -1) {
      (remindersList[index]["isEnabled"] as RxBool).value = value;
      remindersList.refresh();
      Get.snackbar(
        "Reminder Updated",
        "${remindersList[index]['name']} has been ${value ? 'enabled' : 'disabled'}.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff0B0817).withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Snooze adjustment
  void updateSnooze(int id, int minutes) {
    final index = remindersList.indexWhere((r) => r["id"] == id);
    if (index != -1) {
      remindersList[index]["snoozeDuration"] = minutes;
      remindersList.refresh();
      Get.snackbar(
        "Snooze Updated",
        "Snooze duration set to $minutes mins.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff0B0817).withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Add new reminder
  void addReminder(String name, String type, String time, List<String> days, int snooze) {
    final newId = remindersList.isEmpty ? 1 : (remindersList.map<int>((r) => r["id"] as int).reduce((a, b) => a > b ? a : b) + 1);
    remindersList.add({
      "id": newId,
      "name": name,
      "type": type,
      "time": time,
      "days": days.isEmpty ? ["Everyday"] : days,
      "isEnabled": true.obs,
      "snoozeDuration": snooze,
    });
    remindersList.refresh();
    Get.snackbar(
      "Reminder Created",
      "Successfully scheduled '$name'.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff0B0817).withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  // Delete reminder
  void deleteReminder(int id) {
    final index = remindersList.indexWhere((r) => r["id"] == id);
    if (index != -1) {
      final name = remindersList[index]["name"];
      remindersList.removeAt(index);
      remindersList.refresh();
      Get.snackbar(
        "Reminder Deleted",
        "'$name' has been removed.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff0B0817).withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}
