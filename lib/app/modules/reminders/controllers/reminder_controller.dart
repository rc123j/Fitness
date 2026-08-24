import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nutri_shape/app/services/notification_service.dart';
import '../../notifications/controllers/notification_controller.dart';

class ReminderController extends GetxController {
  final _box = GetStorage();
  static const _storageKey = 'user_reminders';

  // Start with empty list — user creates their own reminders
  final remindersList = <Map<String, dynamic>>[].obs;

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

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
    _requestPermissionsAndScheduleAll();
  }

  /// Load persisted reminders from storage
  void _loadFromStorage() {
    final stored = _box.read<List>(_storageKey) ?? [];
    remindersList.assignAll(
      stored.map<Map<String, dynamic>>((item) {
        final map = Map<String, dynamic>.from(item as Map);
        map['isEnabled'] = (map['isEnabled'] as bool? ?? true).obs;
        map['days'] = List<String>.from(map['days'] ?? ['Everyday']);
        return map;
      }).toList(),
    );
  }

  /// Save current reminders to storage
  void _saveToStorage() {
    final toSave = remindersList.map((r) => {
      'id': r['id'],
      'name': r['name'],
      'type': r['type'],
      'time': r['time'],
      'days': r['days'],
      'isEnabled': (r['isEnabled'] as RxBool).value,
      'snoozeDuration': r['snoozeDuration'],
    }).toList();
    _box.write(_storageKey, toSave);
  }

  /// Request notification permissions from the OS and schedule all enabled reminders
  Future<void> _requestPermissionsAndScheduleAll() async {
    final status = await Permission.notification.request();
    if (!status.isGranted) return;

    for (final reminder in remindersList) {
      final bool enabled = (reminder["isEnabled"] as RxBool).value;
      if (enabled) {
        await _scheduleNotification(reminder);
      }
    }
  }

  /// Schedules the notification for a reminder map
  Future<void> _scheduleNotification(Map<String, dynamic> reminder) async {
    final int id = reminder["id"] as int;
    final String name = reminder["name"] as String;
    final String type = reminder["type"] as String;
    final String time = reminder["time"] as String;
    final List<String> days = List<String>.from(reminder["days"] as List);

    final body = NotificationService.buildBody(type, name);

    await NotificationService.instance.scheduleReminder(
      id: id,
      title: name,
      body: body,
      time: time,
      days: days,
      onFired: () {
        // Also log to in-app notification screen
        NotificationController.addFromReminder(
          title: name,
          body: body,
          category: 'Reminders',
        );
      },
    );
  }

  // Toggle reminder ON/OFF
  void toggleReminder(int id, bool value) async {
    final index = remindersList.indexWhere((r) => r["id"] == id);
    if (index == -1) return;

    (remindersList[index]["isEnabled"] as RxBool).value = value;
    remindersList.refresh();
    _saveToStorage();

    if (value) {
      await _scheduleNotification(remindersList[index]);
    } else {
      await NotificationService.instance.cancelReminder(id);
    }

    Get.snackbar(
      value ? "🔔 Reminder On" : "🔕 Reminder Off",
      "${remindersList[index]['name']} has been ${value ? 'enabled' : 'disabled'}.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff0B0817).withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
    );
  }

  // Snooze adjustment
  void updateSnooze(int id, int minutes) {
    final index = remindersList.indexWhere((r) => r["id"] == id);
    if (index != -1) {
      remindersList[index]["snoozeDuration"] = minutes;
      remindersList.refresh();
      _saveToStorage();
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
  void addReminder(String name, String type, String time, List<String> days, int snooze) async {
    final newId = remindersList.isEmpty
        ? 1
        : (remindersList.map<int>((r) => r["id"] as int).reduce((a, b) => a > b ? a : b) + 1);

    final newReminder = {
      "id": newId,
      "name": name,
      "type": type,
      "time": time,
      "days": days.isEmpty ? ["Everyday"] : days,
      "isEnabled": true.obs,
      "snoozeDuration": snooze,
    };

    remindersList.add(newReminder);
    remindersList.refresh();
    _saveToStorage();

    await _scheduleNotification(newReminder);

    Get.snackbar(
      "🔔 Reminder Created",
      "Successfully scheduled '$name'.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff0B0817).withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  // Delete reminder
  void deleteReminder(int id) async {
    final index = remindersList.indexWhere((r) => r["id"] == id);
    if (index != -1) {
      final name = remindersList[index]["name"];
      await NotificationService.instance.cancelReminder(id);
      remindersList.removeAt(index);
      remindersList.refresh();
      _saveToStorage();
      Get.snackbar(
        "🗑️ Reminder Deleted",
        "'$name' has been removed.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff0B0817).withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}
