import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import '../models/app_settings.dart';
import '../core/services/notification_service.dart';
import '../core/services/storage_service.dart';

class AppSettingsProvider with ChangeNotifier {
  AppSettings _settings = const AppSettings();
  bool _isInitialized = false;

  AppSettings get settings => _settings;
  bool get isInitialized => _isInitialized;
  
  // Convenience getters
  bool get notificationsEnabled => _settings.notificationsEnabled;
  TimeOfDay get reminderStartTime => _settings.reminderStartTime;
  TimeOfDay get reminderEndTime => _settings.reminderEndTime;
  int get reminderIntervalMinutes => _settings.reminderIntervalMinutes;
  String get language => _settings.language;
  ThemeMode get themeMode => _settings.themeMode;
  bool get isFirstLaunch => _settings.isFirstLaunch;
  bool get onboardingCompleted => _settings.onboardingCompleted;

  Future<void> initialize() async {
    await _loadSettings();
    _isInitialized = true;
    
    // 如果是第一次启动且默认启用了通知，需要正确初始化通知
    if (_settings.isFirstLaunch && _settings.notificationsEnabled) {
      await _handleFirstLaunchNotificationSetup();
    }
    
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _settings = AppSettings(
        notificationsEnabled: prefs.getBool('notifications_enabled') ?? true,
        reminderStartTime: TimeOfDay(
          hour: prefs.getInt('reminder_start_hour') ?? 9,
          minute: prefs.getInt('reminder_start_minute') ?? 0,
        ),
        reminderEndTime: TimeOfDay(
          hour: prefs.getInt('reminder_end_hour') ?? 21,
          minute: prefs.getInt('reminder_end_minute') ?? 0,
        ),
        reminderIntervalMinutes: prefs.getInt('reminder_interval_minutes') ?? 120,
        language: prefs.getString('language') ?? _getSystemLanguage(),
        themeMode: ThemeMode.values[prefs.getInt('theme_mode') ?? 0],
        isFirstLaunch: prefs.getBool('is_first_launch') ?? true,
        onboardingCompleted: prefs.getBool('onboarding_completed') ?? false,
      );
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('notifications_enabled', _settings.notificationsEnabled);
      await prefs.setInt('reminder_start_hour', _settings.reminderStartTime.hour);
      await prefs.setInt('reminder_start_minute', _settings.reminderStartTime.minute);
      await prefs.setInt('reminder_end_hour', _settings.reminderEndTime.hour);
      await prefs.setInt('reminder_end_minute', _settings.reminderEndTime.minute);
      await prefs.setInt('reminder_interval_minutes', _settings.reminderIntervalMinutes);
      await prefs.setString('language', _settings.language);
      await prefs.setInt('theme_mode', _settings.themeMode.index);
      await prefs.setBool('is_first_launch', _settings.isFirstLaunch);
      await prefs.setBool('onboarding_completed', _settings.onboardingCompleted);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    _settings = _settings.copyWith(notificationsEnabled: enabled);
    await _saveSettings();
    
    if (enabled) {
      await _scheduleNotifications();
    } else {
      await NotificationService.cancelAllReminders();
    }
    
    notifyListeners();
  }

  Future<void> updateReminderStartTime(TimeOfDay time) async {
    _settings = _settings.copyWith(reminderStartTime: time);
    await _saveSettings();
    
    if (_settings.notificationsEnabled) {
      await _scheduleNotifications();
    }
    
    notifyListeners();
  }

  Future<void> updateReminderEndTime(TimeOfDay time) async {
    _settings = _settings.copyWith(reminderEndTime: time);
    await _saveSettings();
    
    if (_settings.notificationsEnabled) {
      await _scheduleNotifications();
    }
    
    notifyListeners();
  }

  Future<void> updateReminderIntervalMinutes(int intervalMinutes) async {
    _settings = _settings.copyWith(reminderIntervalMinutes: intervalMinutes);
    await _saveSettings();
    
    if (_settings.notificationsEnabled) {
      await _scheduleNotifications();
    }
    
    notifyListeners();
  }

  Future<void> updateLanguage(String language) async {
    _settings = _settings.copyWith(language: language);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _settings = _settings.copyWith(
      onboardingCompleted: true,
      isFirstLaunch: false,
    );
    await _saveSettings();
    notifyListeners();
  }

  Future<void> markFirstLaunchComplete() async {
    _settings = _settings.copyWith(isFirstLaunch: false);
    await _saveSettings();
    notifyListeners();
  }

  Future<void> resetSettings() async {
    // 重置设置数据
    _settings = const AppSettings();
    await _saveSettings();
    
    // 清除所有习惯数据
    try {
      await StorageService.clearAllData();
    } catch (e) {
      debugPrint('Error clearing habit data: $e');
    }
    
    notifyListeners();
  }

  Future<void> _scheduleNotifications() async {
    try {
      await NotificationService.scheduleIntervalReminders(
        startTime: _settings.reminderStartTime,
        endTime: _settings.reminderEndTime,
        intervalMinutes: _settings.reminderIntervalMinutes,
        title: 'Neverr 提醒',
        body: '该进行今日的习惯练习了！',
      );
    } catch (e) {
      debugPrint('Failed to schedule notifications: $e');
      // If scheduling fails, disable notifications
      _settings = _settings.copyWith(notificationsEnabled: false);
      await _saveSettings();
      notifyListeners();
    }
  }

  Future<void> setupInitialNotification() async {
    final hasPermission = await NotificationService.requestPermission();
    if (hasPermission) {
      _settings = _settings.copyWith(notificationsEnabled: true);
      await _saveSettings();
      await _scheduleNotifications();
    } else {
      _settings = _settings.copyWith(notificationsEnabled: false);
      await _saveSettings();
    }
    notifyListeners();
  }

  Future<void> _handleFirstLaunchNotificationSetup() async {
    debugPrint('First launch notification setup started');
    
    // 检查是否已有通知权限
    final hasPermission = await NotificationService.hasPermission();
    
    if (hasPermission) {
      // 如果已有权限，直接设置通知
      debugPrint('Notification permission already granted, setting up notifications');
      await _scheduleNotifications();
    } else {
      // 如果没有权限，将默认的通知开启状态改为关闭
      // 不在第一次启动时弹出权限请求，让用户主动选择
      debugPrint('No notification permission, disabling default notification setting');
      _settings = _settings.copyWith(notificationsEnabled: false);
      await _saveSettings();
    }
    
    // 标记第一次启动完成
    await markFirstLaunchComplete();
    debugPrint('First launch notification setup completed');
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) {
      return '深夜了，早点休息';
    } else if (hour < 12) {
      return '早上好';
    } else if (hour < 18) {
      return '下午好';
    } else {
      return '晚上好';
    }
  }

  String getMotivationalMessage() {
    final messages = [
      '每一次重复，都是改变的开始',
      '你的声音，就是改变的力量',
      '坚持下去，你会感谢今天的自己',
      '改变从现在开始，从这一刻开始',
      '相信自己，你比想象中更强大',
    ];
    
    final index = DateTime.now().day % messages.length;
    return messages[index];
  }

  /// 获取系统语言，如果是中文则返回'zh'，否则返回'en'
  String _getSystemLanguage() {
    try {
      final systemLocale = ui.PlatformDispatcher.instance.locale;
      if (systemLocale.languageCode == 'zh') {
        return 'zh';
      } else {
        return 'en';
      }
    } catch (e) {
      debugPrint('Error getting system language: $e');
      return 'en'; // 默认回退到英文
    }
  }
}