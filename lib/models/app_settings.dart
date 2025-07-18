import 'package:flutter/material.dart';

class AppSettings {
  final bool notificationsEnabled;
  final TimeOfDay reminderTime;
  final String language;
  final ThemeMode themeMode;
  final bool isFirstLaunch;
  final bool onboardingCompleted;

  const AppSettings({
    this.notificationsEnabled = true,
    this.reminderTime = const TimeOfDay(hour: 9, minute: 0),
    this.language = 'zh',
    this.themeMode = ThemeMode.system,
    this.isFirstLaunch = true,
    this.onboardingCompleted = false,
  });

  AppSettings copyWith({
    bool? notificationsEnabled,
    TimeOfDay? reminderTime,
    String? language,
    ThemeMode? themeMode,
    bool? isFirstLaunch,
    bool? onboardingCompleted,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'reminderTimeHour': reminderTime.hour,
      'reminderTimeMinute': reminderTime.minute,
      'language': language,
      'themeMode': themeMode.index,
      'isFirstLaunch': isFirstLaunch,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      reminderTime: TimeOfDay(
        hour: map['reminderTimeHour'] ?? 9,
        minute: map['reminderTimeMinute'] ?? 0,
      ),
      language: map['language'] ?? 'zh',
      themeMode: ThemeMode.values[map['themeMode'] ?? 0],
      isFirstLaunch: map['isFirstLaunch'] ?? true,
      onboardingCompleted: map['onboardingCompleted'] ?? false,
    );
  }

  @override
  String toString() {
    return 'AppSettings(notificationsEnabled: $notificationsEnabled, reminderTime: $reminderTime, language: $language, themeMode: $themeMode, isFirstLaunch: $isFirstLaunch, onboardingCompleted: $onboardingCompleted)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          notificationsEnabled == other.notificationsEnabled &&
          reminderTime == other.reminderTime &&
          language == other.language &&
          themeMode == other.themeMode &&
          isFirstLaunch == other.isFirstLaunch &&
          onboardingCompleted == other.onboardingCompleted;

  @override
  int get hashCode {
    return notificationsEnabled.hashCode ^
        reminderTime.hashCode ^
        language.hashCode ^
        themeMode.hashCode ^
        isFirstLaunch.hashCode ^
        onboardingCompleted.hashCode;
  }
}