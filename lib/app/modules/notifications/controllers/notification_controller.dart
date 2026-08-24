import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  final _box = GetStorage();
  static const _storageKey = 'app_notifications';

  final notificationsList = <Map<String, dynamic>>[].obs;

  // Selected Filter Category
  final selectedFilter = "All".obs;

  // Filters list
  final filtersList = ["All", "Alerts", "Reminders", "Nutrition", "Progress"];

  // Filtered getter
  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter.value == "All") {
      return notificationsList;
    }
    return notificationsList.where((n) => n["category"] == selectedFilter.value).toList();
  }

  // Count of unread notifications
  int get unreadCount => notificationsList.where((n) => !(n["isRead"] as RxBool).value).length;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  /// Load saved notifications from persistent storage
  void _loadFromStorage() {
    final stored = _box.read<List>(_storageKey) ?? [];
    notificationsList.assignAll(
      stored.map<Map<String, dynamic>>((item) {
        final map = Map<String, dynamic>.from(item as Map);
        map['isRead'] = (map['isRead'] as bool? ?? false).obs;
        return map;
      }).toList(),
    );
  }

  /// Persist current notifications to storage
  void _saveToStorage() {
    final toSave = notificationsList.map((item) {
      return {
        'id': item['id'],
        'title': item['title'],
        'body': item['body'],
        'timestamp': item['timestamp'],
        'category': item['category'],
        'isRead': (item['isRead'] as RxBool).value,
      };
    }).toList();
    _box.write(_storageKey, toSave);
  }

  /// Add a notification from a fired reminder (called by NotificationService callback)
  static void addFromReminder({
    required String title,
    required String body,
    String category = 'Reminders',
  }) {
    try {
      final controller = Get.find<NotificationController>();
      controller.addNotification(title: title, body: body, category: category);
    } catch (_) {
      // Controller not yet registered — store directly
      final box = GetStorage();
      final stored = box.read<List>('app_notifications') ?? [];
      final newId = stored.isEmpty ? 1 : (stored.last['id'] as int? ?? 0) + 1;
      stored.insert(0, {
        'id': newId,
        'title': title,
        'body': body,
        'timestamp': DateTime.now().toIso8601String(),
        'category': category,
        'isRead': false,
      });
      box.write('app_notifications', stored);
    }
  }

  /// Add a notification programmatically
  void addNotification({
    required String title,
    required String body,
    String category = 'Alerts',
  }) {
    final newId = notificationsList.isEmpty
        ? 1
        : (notificationsList.map<int>((n) => n['id'] as int).reduce((a, b) => a > b ? a : b) + 1);

    notificationsList.insert(0, {
      'id': newId,
      'title': title,
      'body': body,
      'timestamp': DateTime.now().toIso8601String(),
      'category': category,
      'isRead': false.obs,
    });
    notificationsList.refresh();
    _saveToStorage();
  }

  // Mark single as read
  void markAsRead(int id) {
    final index = notificationsList.indexWhere((n) => n["id"] == id);
    if (index != -1) {
      (notificationsList[index]["isRead"] as RxBool).value = true;
      notificationsList.refresh();
      _saveToStorage();
    }
  }

  // Mark all as read
  void markAllAsRead() {
    for (var item in notificationsList) {
      (item["isRead"] as RxBool).value = true;
    }
    notificationsList.refresh();
    _saveToStorage();
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
      _saveToStorage();
    }
  }

  // Clear all notifications
  void clearAll() {
    notificationsList.clear();
    notificationsList.refresh();
    _saveToStorage();
    Get.snackbar(
      "Cleared",
      "Notifications history cleared.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff0B0817).withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  /// Format stored ISO timestamp to human-readable string
  static String formatTimestamp(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
      if (diff.inHours < 24) return '${diff.inHours} hrs ago';
      if (diff.inDays == 1) return 'Yesterday';
      return '${diff.inDays} days ago';
    } catch (_) {
      return isoString;
    }
  }
}
