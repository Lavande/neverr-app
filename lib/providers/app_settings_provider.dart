import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_settings.dart';
import '../core/services/notification_service.dart';

class AppSettingsProvider with ChangeNotifier {
  AppSettings _settings = const AppSettings();
  bool _isInitialized = false;

  AppSettings get settings => _settings;
  bool get isInitialized => _isInitialized;
  
  // Convenience getters
  bool get notificationsEnabled => _settings.notificationsEnabled;
  TimeOfDay get reminderTime => _settings.reminderTime;
  String get language => _settings.language;
  ThemeMode get themeMode => _settings.themeMode;
  bool get isFirstLaunch => _settings.isFirstLaunch;
  bool get onboardingCompleted => _settings.onboardingCompleted;

  Future<void> initialize() async {
    await _loadSettings();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _settings = AppSettings(
        notificationsEnabled: prefs.getBool('notifications_enabled') ?? true,
        reminderTime: TimeOfDay(
          hour: prefs.getInt('reminder_hour') ?? 9,
          minute: prefs.getInt('reminder_minute') ?? 0,
        ),
        language: prefs.getString('language') ?? 'zh',
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
      await prefs.setInt('reminder_hour', _settings.reminderTime.hour);
      await prefs.setInt('reminder_minute', _settings.reminderTime.minute);
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
      await _scheduleNotification();
    } else {
      await NotificationService.cancelDailyReminder();
    }
    
    notifyListeners();
  }

  Future<void> updateReminderTime(TimeOfDay time) async {
    _settings = _settings.copyWith(reminderTime: time);
    await _saveSettings();
    
    if (_settings.notificationsEnabled) {
      await _scheduleNotification();
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
    _settings = const AppSettings();
    await _saveSettings();
    notifyListeners();
  }

  Future<void> _scheduleNotification() async {
    await NotificationService.scheduleDailyReminder(
      time: _settings.reminderTime,
      title: 'Neverr 提醒',
      body: '该进行今日的习惯练习了！',
    );
  }

  Future<void> setupInitialNotification() async {
    if (_settings.notificationsEnabled) {
      final hasPermission = await NotificationService.requestPermission();
      if (hasPermission) {
        await _scheduleNotification();
      } else {
        await updateNotificationsEnabled(false);
      }
    }
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
}