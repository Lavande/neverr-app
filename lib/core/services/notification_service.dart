import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:io';

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
    
    // Create notification channels explicitly
    await _createNotificationChannels();
  }

  static Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      const AndroidNotificationChannel dailyChannel = AndroidNotificationChannel(
        'daily_reminder',
        'Daily Reminder',
        description: 'Daily reminder to practice your habits',
        importance: Importance.max,
        enableVibration: true,
        enableLights: true,
        showBadge: true,
      );

      const AndroidNotificationChannel intervalChannel = AndroidNotificationChannel(
        'interval_reminder',
        'Interval Reminder',
        description: 'Interval reminders for habit practice',
        importance: Importance.max,
        enableVibration: true,
        enableLights: true,
        showBadge: true,
      );

      const AndroidNotificationChannel instantChannel = AndroidNotificationChannel(
        'instant_notification',
        'Instant Notification',
        description: 'Instant notifications for user actions',
        importance: Importance.max,
        enableVibration: true,
        enableLights: true,
        showBadge: true,
      );

      const AndroidNotificationChannel simpleTestChannel = AndroidNotificationChannel(
        'test_simple',
        'Simple Test',
        description: 'Simple test notification',
        importance: Importance.max,
        enableVibration: true,
        enableLights: true,
        showBadge: true,
      );

      await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(dailyChannel);
      await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(intervalChannel);
      await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(instantChannel);
      await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(simpleTestChannel);
          
      debugPrint('Notification channels created');
    }
  }

  static Future<bool> requestPermission() async {
    debugPrint('Requesting notification permissions...');
    
    // First request basic notification permission
    final status = await Permission.notification.status;
    debugPrint('Current notification permission status: $status');
    
    bool notificationGranted = false;
    
    if (status.isDenied) {
      debugPrint('Requesting notification permission...');
      final newStatus = await Permission.notification.request();
      notificationGranted = newStatus.isGranted;
      debugPrint('New notification permission status: $newStatus');
    } else if (status.isPermanentlyDenied) {
      debugPrint('Notification permission permanently denied');
      return false;
    } else {
      notificationGranted = status.isGranted;
    }
    
    // On Android, also request additional permissions for better reliability
    if (Platform.isAndroid && notificationGranted) {
      try {
        // Request exact alarm permission for Android 12+
        final scheduleExactAlarmStatus = await Permission.scheduleExactAlarm.status;
        debugPrint('Schedule exact alarm permission status: $scheduleExactAlarmStatus');
        if (scheduleExactAlarmStatus.isDenied) {
          debugPrint('Requesting schedule exact alarm permission...');
          final result = await Permission.scheduleExactAlarm.request();
          debugPrint('Schedule exact alarm permission result: $result');
        }
      } catch (e) {
        debugPrint('Schedule exact alarm permission not available: $e');
      }
      
      // Request battery optimization exemption
      try {
        final ignoreBatteryOptimizationStatus = await Permission.ignoreBatteryOptimizations.status;
        debugPrint('Battery optimization permission status: $ignoreBatteryOptimizationStatus');
        if (ignoreBatteryOptimizationStatus.isDenied) {
          debugPrint('Requesting battery optimization exemption...');
          final result = await Permission.ignoreBatteryOptimizations.request();
          debugPrint('Battery optimization exemption result: $result');
        }
      } catch (e) {
        debugPrint('Battery optimization permission not available: $e');
      }
    }
    
    debugPrint('Final notification permission granted: $notificationGranted');
    return notificationGranted;
  }

  static Future<bool> hasPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }

  // Test instant notification
  static Future<void> testInstantNotification() async {
    try {
      debugPrint('Testing instant notification...');
      
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'test_simple',
        'Simple Test',
        channelDescription: 'Simple test notification',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
        ticker: 'Test notification',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: null,
      );

      await _notificationsPlugin.show(
        998,
        'Instant Test Notification',
        'This should appear immediately to test basic notification functionality',
        notificationDetails,
      );
      
      debugPrint('Instant notification sent successfully');
    } catch (e) {
      debugPrint('Failed to send instant notification: $e');
    }
  }

  // Simple test notification using basic scheduling
  static Future<void> scheduleSimpleTestNotification() async {
    try {
      debugPrint('Scheduling simple test notification...');
      
      // First test if instant notification works
      await testInstantNotification();
      
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'test_simple',
        'Simple Test',
        channelDescription: 'Simple test notification',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
        ticker: 'Scheduled notification',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: null,
      );

      final scheduledTime = DateTime.now().add(const Duration(seconds: 30));
      final tzDateTime = tz.TZDateTime.from(scheduledTime, _TimeZoneHelper.local);
      
      debugPrint('Current time: ${DateTime.now()}');
      debugPrint('Scheduled time: $scheduledTime');
      debugPrint('TZ Scheduled time: $tzDateTime');
      debugPrint('Using timezone: ${_TimeZoneHelper.local.name}');

      await _notificationsPlugin.zonedSchedule(
        999,
        'Scheduled Test Notification',
        'This should appear in 30 seconds - scheduled at ${DateTime.now().toString()}',
        tzDateTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      
      debugPrint('Simple notification scheduled successfully');
    } catch (e) {
      debugPrint('Failed to schedule simple notification: $e');
    }
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
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'daily_reminder',
        'Daily Reminder',
        channelDescription: 'Daily reminder to practice your habits',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
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
      
      debugPrint('Daily reminder scheduled for ${time.hour}:${time.minute}');
    } catch (e) {
      debugPrint('Failed to schedule daily reminder: $e');
      throw e;
    }
  }

  static Future<void> scheduleIntervalReminders({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int intervalMinutes,
    required String title,
    required String body,
  }) async {
    try {
      // Cancel all existing reminders first
      await cancelAllReminders();

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'interval_reminder',
        'Interval Reminder',
        channelDescription: 'Interval reminders for habit practice',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
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
        try {
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
          
          debugPrint('Interval reminder scheduled for ${reminderTime.hour}:${reminderTime.minute}');
        } catch (e) {
          debugPrint('Failed to schedule notification for ${reminderTime.hour}:${reminderTime.minute}: $e');
          // Continue with other notifications even if one fails
        }
      }
      
      debugPrint('Total ${reminderTimes.length} interval reminders scheduled');
    } catch (e) {
      debugPrint('Failed to schedule interval reminders: $e');
      throw e;
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
    try {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'instant_notification',
        'Instant Notification',
        channelDescription: 'Instant notifications for user actions',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        enableLights: true,
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
      
      debugPrint('Instant notification sent: $title - $body');
    } catch (e) {
      debugPrint('Failed to show instant notification: $e');
    }
  }

  static TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final location = _TimeZoneHelper.local;
    final now = TZDateTime.now(location);
    
    debugPrint('Current timezone: ${location.name}');
    debugPrint('Current time: ${now.toString()}');
    debugPrint('Target time: ${time.hour}:${time.minute}');
    
    TZDateTime scheduledDate = TZDateTime(
      location,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    
    debugPrint('Initial scheduled date: ${scheduledDate.toString()}');
    debugPrint('Is scheduled date before now? ${scheduledDate.isBefore(now)}');
    
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
      debugPrint('Moved to next day: ${scheduledDate.toString()}');
    }
    
    final diffMinutes = scheduledDate.difference(now).inMinutes;
    debugPrint('Notification will trigger in $diffMinutes minutes');
    
    return scheduledDate;
  }
}

class _TimeZoneHelper {
  static bool _initialized = false;
  static tz.Location? _cachedLocation;
  
  static Future<void> initialize() async {
    if (!_initialized) {
      tz_data.initializeTimeZones();
      _initialized = true;
      debugPrint('TimeZone data initialized');
      
      // Pre-cache the local timezone
      _cachedLocation = _getLocalLocation();
      debugPrint('Cached timezone: ${_cachedLocation?.name}');
    }
  }
  
  static tz.Location get local {
    if (_cachedLocation != null) {
      return _cachedLocation!;
    }
    
    _cachedLocation = _getLocalLocation();
    return _cachedLocation!;
  }
  
  static tz.Location _getLocalLocation() {
    try {
      final offset = DateTime.now().timeZoneOffset;
      final systemTimeZone = DateTime.now().timeZoneName;
      debugPrint('System timezone: $systemTimeZone, offset: ${offset.inHours}h');
      
      // Try to map common timezones
      switch (offset.inHours) {
        case 8:
          return tz.getLocation('Asia/Shanghai');
        case 9:
          return tz.getLocation('Asia/Tokyo');
        case -8:
          return tz.getLocation('America/Los_Angeles');
        case -5:
          return tz.getLocation('America/New_York');
        case 0:
          return tz.getLocation('UTC');
        default:
          // Try to find a timezone matching the offset
          final locations = tz.timeZoneDatabase.locations.values.where(
            (location) => tz.TZDateTime.now(location).timeZoneOffset == offset
          );
          
          if (locations.isNotEmpty) {
            debugPrint('Found matching timezone: ${locations.first.name}');
            return locations.first;
          }
          
          // Fallback to local or UTC
          try {
            return tz.local;
          } catch (e) {
            debugPrint('Failed to get tz.local: $e');
            return tz.UTC;
          }
      }
    } catch (e) {
      debugPrint('Failed to determine timezone: $e, using UTC');
      return tz.UTC;
    }
  }
}

typedef TZDateTime = tz.TZDateTime;