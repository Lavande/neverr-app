import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await _TimeZoneHelper.initialize();
    
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  static Future<bool> requestPermission() async {
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      return status.isGranted;
    }
    return true;
  }

  static void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap
    // print('Notification tapped: ${response.payload}');
  }

  static Future<void> scheduleDailyReminder({
    required TimeOfDay time,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'daily_reminder',
      'Daily Reminder',
      channelDescription: 'Daily reminder to practice your habits',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      _nextInstanceOfTime(time),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleIntervalReminders({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int intervalMinutes,
    required String title,
    required String body,
  }) async {
    // Cancel all existing reminders first
    await cancelAllReminders();

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'interval_reminder',
      'Interval Reminder',
      channelDescription: 'Interval reminders for habit practice',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    // Calculate all reminder times within the interval
    final reminderTimes = _calculateReminderTimes(startTime, endTime, intervalMinutes);
    
    int notificationId = 1000; // Start with a base ID for interval reminders
    
    for (final reminderTime in reminderTimes) {
      await _notificationsPlugin.zonedSchedule(
        notificationId++,
        title,
        body,
        _nextInstanceOfTime(reminderTime),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static List<TimeOfDay> _calculateReminderTimes(
    TimeOfDay startTime,
    TimeOfDay endTime,
    int intervalMinutes,
  ) {
    final List<TimeOfDay> reminderTimes = [];
    
    // Convert to minutes for easier calculation
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;
    
    // Handle case where end time is next day (e.g., 23:00 to 01:00)
    if (endMinutes <= startMinutes) {
      endMinutes += 24 * 60; // Add 24 hours
    }
    
    int currentMinutes = startMinutes;
    
    while (currentMinutes <= endMinutes) {
      int hours = (currentMinutes ~/ 60) % 24;
      int minutes = currentMinutes % 60;
      
      reminderTimes.add(TimeOfDay(hour: hours, minute: minutes));
      currentMinutes += intervalMinutes;
    }
    
    return reminderTimes;
  }

  static Future<void> cancelDailyReminder() async {
    await _notificationsPlugin.cancel(0);
  }

  static Future<void> cancelAllReminders() async {
    await _notificationsPlugin.cancelAll();
  }

  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'instant_notification',
      'Instant Notification',
      channelDescription: 'Instant notifications for user actions',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
    );
  }

  static TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final location = _TimeZoneHelper.local;
    final now = TZDateTime.now(location);
    TZDateTime scheduledDate = TZDateTime(
      location,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }
}

class _TimeZoneHelper {
  static bool _initialized = false;
  
  static Future<void> initialize() async {
    if (!_initialized) {
      tz_data.initializeTimeZones();
      _initialized = true;
    }
  }
  
  static tz.Location get local => tz.getLocation('Asia/Shanghai');
}

typedef TZDateTime = tz.TZDateTime;