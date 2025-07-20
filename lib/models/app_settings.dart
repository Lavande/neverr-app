import 'package:flutter/material.dart';

class AppSettings {
  final bool notificationsEnabled;
  final TimeOfDay reminderStartTime;
  final TimeOfDay reminderEndTime;
  final int reminderIntervalMinutes; // 直接存储间隔分钟数
  final String language;
  final ThemeMode themeMode;
  final bool isFirstLaunch;
  final bool onboardingCompleted;

  const AppSettings({
    this.notificationsEnabled = true,
    this.reminderStartTime = const TimeOfDay(hour: 9, minute: 0),
    this.reminderEndTime = const TimeOfDay(hour: 21, minute: 0),
    this.reminderIntervalMinutes = 30, // 默认30分钟
    this.language = 'zh',
    this.themeMode = ThemeMode.system,
    this.isFirstLaunch = true,
    this.onboardingCompleted = false,
  });

  AppSettings copyWith({
    bool? notificationsEnabled,
    TimeOfDay? reminderStartTime,
    TimeOfDay? reminderEndTime,
    int? reminderIntervalMinutes,
    String? language,
    ThemeMode? themeMode,
    bool? isFirstLaunch,
    bool? onboardingCompleted,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderStartTime: reminderStartTime ?? this.reminderStartTime,
      reminderEndTime: reminderEndTime ?? this.reminderEndTime,
      reminderIntervalMinutes: reminderIntervalMinutes ?? this.reminderIntervalMinutes,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'reminderStartTimeHour': reminderStartTime.hour,
      'reminderStartTimeMinute': reminderStartTime.minute,
      'reminderEndTimeHour': reminderEndTime.hour,
      'reminderEndTimeMinute': reminderEndTime.minute,
      'reminderIntervalMinutes': reminderIntervalMinutes,
      'language': language,
      'themeMode': themeMode.index,
      'isFirstLaunch': isFirstLaunch,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      reminderStartTime: TimeOfDay(
        hour: map['reminderStartTimeHour'] ?? 9,
        minute: map['reminderStartTimeMinute'] ?? 0,
      ),
      reminderEndTime: TimeOfDay(
        hour: map['reminderEndTimeHour'] ?? 21,
        minute: map['reminderEndTimeMinute'] ?? 0,
      ),
      reminderIntervalMinutes: map['reminderIntervalMinutes'] ?? 30,
      language: map['language'] ?? 'zh',
      themeMode: ThemeMode.values[map['themeMode'] ?? 0],
      isFirstLaunch: map['isFirstLaunch'] ?? true,
      onboardingCompleted: map['onboardingCompleted'] ?? false,
    );
  }

  // 获取提醒时间区间的显示文本
  String getReminderTimeRangeDisplayText(BuildContext context) {
    return '${reminderStartTime.format(context)} - ${reminderEndTime.format(context)}';
  }

  @override
  String toString() {
    return 'AppSettings(notificationsEnabled: $notificationsEnabled, reminderStartTime: $reminderStartTime, reminderEndTime: $reminderEndTime, reminderIntervalMinutes: $reminderIntervalMinutes, language: $language, themeMode: $themeMode, isFirstLaunch: $isFirstLaunch, onboardingCompleted: $onboardingCompleted)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          notificationsEnabled == other.notificationsEnabled &&
          reminderStartTime == other.reminderStartTime &&
          reminderEndTime == other.reminderEndTime &&
          reminderIntervalMinutes == other.reminderIntervalMinutes &&
          language == other.language &&
          themeMode == other.themeMode &&
          isFirstLaunch == other.isFirstLaunch &&
          onboardingCompleted == other.onboardingCompleted;

  @override
  int get hashCode {
    return notificationsEnabled.hashCode ^
        reminderStartTime.hashCode ^
        reminderEndTime.hashCode ^
        reminderIntervalMinutes.hashCode ^
        language.hashCode ^
        themeMode.hashCode ^
        isFirstLaunch.hashCode ^
        onboardingCompleted.hashCode;
  }
}