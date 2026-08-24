import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../modules/notifications/controllers/notification_controller.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService _instance = NotificationService._();
  static NotificationService get instance => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // Notification channel details for Android
  static const _androidChannel = AndroidNotificationDetails(
    'nutri_shape_reminders',
    'NutriShape Reminders',
    channelDescription: 'Fitness & nutrition reminders for your daily goals.',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    playSound: true,
    enableVibration: true,
  );

  static const _notificationDetails = NotificationDetails(
    android: _androidChannel,
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  /// Call this once in main() before runApp()
  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    // Resolve the device's actual local timezone (e.g. 'Asia/Kolkata' for IST)
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
    } catch (_) {
      // Fallback: keep UTC if resolution fails
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // When user taps a notification, log it inside the app notification screen
        _logTappedNotification(response);
      },
      onDidReceiveBackgroundNotificationResponse: _backgroundNotificationHandler,
    );
    _initialized = true;
  }

  // Called in background (isolate) when notification tapped while app is closed
  // Must be a top-level function
  static void _backgroundNotificationHandler(NotificationResponse response) {
    _logTappedNotification(response);
  }

  static void _logTappedNotification(NotificationResponse response) {
    try {
      // Payload is 'title|||body' separated string
      final parts = (response.payload ?? '').split('|||');
      final title = parts.isNotEmpty ? parts[0] : 'Reminder';
      final body = parts.length > 1 ? parts[1] : '';
      NotificationController.addFromReminder(title: title, body: body, category: 'Reminders');
    } catch (_) {}
  }

  /// Request notification permission (Android 13+ and iOS)
  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    bool granted = false;

    if (android != null) {
      granted = await android.requestNotificationsPermission() ?? false;
    }
    if (ios != null) {
      granted = await ios.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }
    return granted;
  }

  /// Schedule a daily repeating notification at a given time.
  /// [id] must be unique per reminder.
  /// [days] = ['Everyday'] will repeat every day. Specific days like ['Mon','Fri'] supported too.
  /// [onFired] is an optional callback stored for display purposes (payload-based).
  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required String time, // Format: "08:30 AM" or "08:30 PM"
    required List<String> days,
    VoidCallback? onFired, // currently unused at OS level; logged via tap handler
  }) async {
    await cancelReminder(id);

    final parsed = _parseTime(time);
    if (parsed == null) return;

    final hour = parsed[0];
    final minute = parsed[1];

    if (days.contains('Everyday')) {
      // Schedule a daily recurring notification
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfTime(hour, minute),
        _notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: '$title|||$body',
      );
    } else {
      // Schedule for each specific day individually (unique IDs per day)
      final dayMap = {
        'Mon': DateTime.monday,
        'Tue': DateTime.tuesday,
        'Wed': DateTime.wednesday,
        'Thu': DateTime.thursday,
        'Fri': DateTime.friday,
        'Sat': DateTime.saturday,
        'Sun': DateTime.sunday,
      };

      // Cancel all possible sub-IDs first
      for (int i = 0; i < 7; i++) {
        await _plugin.cancel(id * 10 + i);
      }

      int subId = 0;
      for (final day in days) {
        final weekday = dayMap[day];
        if (weekday == null) continue;
        await _plugin.zonedSchedule(
          id * 10 + subId,
          title,
          body,
          _nextInstanceOfWeekday(hour, minute, weekday),
          _notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: '$title|||$body',
        );
        subId++;
      }
    }
  }

  /// Cancel a scheduled reminder by id
  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id);
    // Also cancel any day-specific sub-notifications
    for (int i = 0; i < 7; i++) {
      await _plugin.cancel(id * 10 + i);
    }
  }

  /// Cancel all pending notifications
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ────────────────────────────── HELPERS ──────────────────────────────

  /// Parse "08:30 AM" or "08:30 PM" → [hour24, minute]
  List<int>? _parseTime(String time) {
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

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  tz.TZDateTime _nextInstanceOfWeekday(int hour, int minute, int weekday) {
    tz.TZDateTime scheduled = _nextInstanceOfTime(hour, minute);
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Build a human-friendly notification body based on reminder type
  static String buildBody(String type, String reminderName) {
    switch (type) {
      case 'Meal':
        return '🍽️ $reminderName — Time to fuel your body with the right macros!';
      case 'Water':
        return '💧 Stay hydrated! Drink a glass of water right now.';
      case 'Supplement':
        return '💊 $reminderName — Don\'t miss your daily supplement intake.';
      case 'Weight Check':
        return '⚖️ Weekly weight check time! Log your weight to track progress.';
      case 'Progress Upload':
        return '📸 Time for your progress body scan! Upload your latest photo.';
      default:
        return '🔔 $reminderName — Time to stay on track with your goals!';
    }
  }
}
