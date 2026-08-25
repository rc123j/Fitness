import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nutri_shape/app/services/notification_service.dart';
import '../../notifications/controllers/notification_controller.dart';

class ReminderController extends GetxController with WidgetsBindingObserver {
  final _box = GetStorage();
  static const _storageKey = 'user_reminders';
  // Separate from _storageKey so seeding is a one-time event tied to this
  // specific flag, not to whether the reminders list happens to be empty
  // (an install that already wrote `[]` to _storageKey pre-defaults would
  // otherwise never get seeded).
  static const _seededKey = 'user_reminders_defaults_seeded';
  // reminder id -> yyyy-MM-dd it was last logged into the in-app
  // notification screen. The OS only tells the app about a fired
  // notification if the user actually taps it, so a reminder the user saw
  // but never tapped would otherwise never show up here — this catches it
  // up by comparing wall-clock time against each reminder's schedule
  // instead of depending on that tap.
  static const _lastLoggedKey = 'user_reminders_last_logged';

  // Seeded with a default set of daily reminders on first launch (see
  // _defaultReminders below); the user can edit, disable, delete, or add
  // their own on top of these from the Reminders screen.
  final remindersList = <Map<String, dynamic>>[].obs;

  /// Default reminders scheduled for every new user — 9 a day covering
  /// meals, hydration and weekly check-ins, so the app has useful nudges
  /// out of the box instead of starting empty.
  static List<Map<String, dynamic>> _defaultReminders() => [
    {
      "id": 1,
      "name": "Breakfast",
      "type": "Meal",
      "time": "08:00 AM",
      "days": ["Everyday"],
      "isEnabled": true.obs,
      "snoozeDuration": 10,
    },
    {
      "id": 2,
      "name": "Morning Hydration",
      "type": "Water",
      "time": "10:00 AM",
      "days": ["Everyday"],
      "isEnabled": true.obs,
      "snoozeDuration": 10,
    },
    {
      "id": 3,
      "name": "Mid-Morning Snack",
      "type": "Meal",
      "time": "11:30 AM",
      "days": ["Everyday"],
      "isEnabled": true.obs,
      "snoozeDuration": 10,
    },
    {
      "id": 4,
      "name": "Lunch",
      "type": "Meal",
      "time": "01:30 PM",
      "days": ["Everyday"],
      "isEnabled": true.obs,
      "snoozeDuration": 10,
    },
    {
      "id": 5,
      "name": "Afternoon Hydration",
      "type": "Water",
      "time": "03:30 PM",
      "days": ["Everyday"],
      "isEnabled": true.obs,
      "snoozeDuration": 10,
    },
    {
      "id": 6,
      "name": "Evening Snack",
      "type": "Meal",
      "time": "05:30 PM",
      "days": ["Everyday"],
      "isEnabled": true.obs,
      "snoozeDuration": 10,
    },
    {
      "id": 7,
      "name": "Evening Hydration",
      "type": "Water",
      "time": "07:00 PM",
      "days": ["Everyday"],
      "isEnabled": true.obs,
      "snoozeDuration": 10,
    },
    {
      "id": 8,
      "name": "Dinner",
      "type": "Meal",
      "time": "08:30 PM",
      "days": ["Everyday"],
      "isEnabled": true.obs,
      "snoozeDuration": 10,
    },
    {
      "id": 9,
      "name": "Weekly Weight Check",
      "type": "Weight Check",
      "time": "09:00 AM",
      "days": ["Sun"],
      "isEnabled": true.obs,
      "snoozeDuration": 10,
    },
  ];

  // Selected Category filter
  final activeFilter = "All".obs;

  // Categories list
  final categories = [
    "All",
    "Meal",
    "Water",
    "Supplement",
    "Weight Check",
    "Progress Upload",
  ];

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
    WidgetsBinding.instance.addObserver(this);
    _loadFromStorage();
    _requestPermissionsAndScheduleAll();
    _logDueReminders();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Catch up on any reminder that fired while the app was backgrounded,
    // in case the user saw the OS notification but never tapped it.
    if (state == AppLifecycleState.resumed) {
      _logDueReminders();
    }
  }

  /// Logs any enabled reminder whose scheduled time has already passed
  /// today (and hasn't been logged for today yet) into the in-app
  /// notification screen — independent of whether the user tapped the OS
  /// notification, since tapping is the only way flutter_local_notifications
  /// tells the app a reminder fired.
  void _logDueReminders() {
    final lastLogged = Map<String, dynamic>.from(
      _box.read<Map>(_lastLoggedKey) ?? {},
    );
    final now = DateTime.now();
    final todayStr =
        "${now.year.toString().padLeft(4, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}";
    const weekdayAbbrev = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final todayAbbrev = weekdayAbbrev[now.weekday - 1];

    bool changed = false;
    for (final reminder in remindersList) {
      final enabled = (reminder["isEnabled"] as RxBool).value;
      if (!enabled) continue;

      final id = (reminder["id"] as int).toString();
      if (lastLogged[id] == todayStr) continue; // already logged today

      final days = List<String>.from(reminder["days"] as List);
      if (!days.contains('Everyday') && !days.contains(todayAbbrev)) continue;

      final parsedTime = _parseReminderTime(reminder["time"] as String);
      if (parsedTime == null) continue;
      final scheduledToday = DateTime(
        now.year,
        now.month,
        now.day,
        parsedTime[0],
        parsedTime[1],
      );
      if (now.isBefore(scheduledToday)) continue; // hasn't fired yet today

      final name = reminder["name"] as String;
      final type = reminder["type"] as String;
      NotificationController.addFromReminder(
        title: name,
        body: NotificationService.buildBody(type, name),
        category: 'Reminders',
      );
      lastLogged[id] = todayStr;
      changed = true;
    }

    if (changed) _box.write(_lastLoggedKey, lastLogged);
  }

  /// Parse "08:30 AM" or "08:30 PM" → [hour24, minute]
  List<int>? _parseReminderTime(String time) {
    try {
      final parts = time.trim().split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      final bool isPm = parts.length > 1 && parts[1].toUpperCase() == 'PM';
      if (isPm && hour != 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      return [hour, minute];
    } catch (_) {
      return null;
    }
  }

  /// Load persisted reminders from storage — the one-time default set gets
  /// merged in (by the _seededKey flag, not list emptiness) the first time
  /// this runs, so it lands even on an install whose storage already has an
  /// empty reminders list saved from before defaults existed.
  void _loadFromStorage() {
    final stored = _box.read<List>(_storageKey) ?? [];
    final loaded = stored.map<Map<String, dynamic>>((item) {
      final map = Map<String, dynamic>.from(item as Map);
      map['isEnabled'] = (map['isEnabled'] as bool? ?? true).obs;
      map['days'] = List<String>.from(map['days'] ?? ['Everyday']);
      return map;
    }).toList();

    final alreadySeeded = _box.read<bool>(_seededKey) ?? false;
    if (!alreadySeeded) {
      final existingIds = loaded.map((r) => r['id'] as int).toSet();
      for (final defaultReminder in _defaultReminders()) {
        if (!existingIds.contains(defaultReminder['id'])) {
          loaded.add(defaultReminder);
        }
      }
      _box.write(_seededKey, true);
    }

    remindersList.assignAll(loaded);
    if (!alreadySeeded) _saveToStorage();
  }

  /// Save current reminders to storage
  void _saveToStorage() {
    final toSave = remindersList
        .map(
          (r) => {
            'id': r['id'],
            'name': r['name'],
            'type': r['type'],
            'time': r['time'],
            'days': r['days'],
            'isEnabled': (r['isEnabled'] as RxBool).value,
            'snoozeDuration': r['snoozeDuration'],
          },
        )
        .toList();
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
  void addReminder(
    String name,
    String type,
    String time,
    List<String> days,
    int snooze,
  ) async {
    final newId = remindersList.isEmpty
        ? 1
        : (remindersList
                  .map<int>((r) => r["id"] as int)
                  .reduce((a, b) => a > b ? a : b) +
              1);

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
