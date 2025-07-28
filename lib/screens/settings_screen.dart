import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_settings_provider.dart';
import '../providers/habit_provider.dart';
import '../l10n/app_localizations.dart';
import '../core/services/notification_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Consumer<AppSettingsProvider>(
            builder: (context, settings, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page title
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text(
                      AppLocalizations.of(context)!.settings,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ),
                // Notifications section
                _buildSection(
                  context,
                  AppLocalizations.of(context)!.notificationSettings,
                  [
                    _buildSwitchTile(
                      context,
                      AppLocalizations.of(context)!.enableNotifications,
                      AppLocalizations.of(context)!.enableNotificationsDescription,
                      settings.notificationsEnabled,
                      (value) async {
                        if (value) {
                          // Request permission first before enabling
                          await settings.setupInitialNotification();
                        } else {
                          await settings.updateNotificationsEnabled(value);
                        }
                      },
                    ),
                    if (settings.notificationsEnabled) ...[
                      _buildReminderTimeRangeTile(
                        context,
                        AppLocalizations.of(context)!.reminderTimeRange,
                        AppLocalizations.of(context)!.reminderTimeRangeDescription,
                        settings.reminderStartTime,
                        settings.reminderEndTime,
                        (startTime) => settings.updateReminderStartTime(startTime),
                        (endTime) => settings.updateReminderEndTime(endTime),
                      ),
                      _buildReminderIntervalTile(
                        context,
                        AppLocalizations.of(context)!.reminderInterval,
                        AppLocalizations.of(context)!.reminderIntervalDescription,
                        settings.reminderIntervalMinutes,
                        (intervalMinutes) => settings.updateReminderIntervalMinutes(intervalMinutes),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: 24),
                
                
                // Language section
                _buildSection(
                  context,
                  AppLocalizations.of(context)!.languageSettings,
                  [
                    _buildDropdownTile(
                      context,
                      AppLocalizations.of(context)!.language,
                      AppLocalizations.of(context)!.selectLanguage,
                      settings.language,
                      {
                        'zh': '中文',
                        'en': 'English',
                      },
                      (value) => settings.updateLanguage(value),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // About section
                _buildSection(
                  context,
                  AppLocalizations.of(context)!.about,
                  [
                    _buildActionTile(
                      context,
                      AppLocalizations.of(context)!.aboutNeverr,
                      AppLocalizations.of(context)!.aboutNeverrDescription,
                      Icons.info_outline,
                      () => _showAboutDialog(context),
                    ),
                    _buildActionTile(
                      context,
                      AppLocalizations.of(context)!.versionInfo,
                      AppLocalizations.of(context)!.version,
                      Icons.smartphone,
                      () {},
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Danger zone
                _buildSection(
                  context,
                  AppLocalizations.of(context)!.dangerZone,
                  [
                    _buildActionTile(
                      context,
                      AppLocalizations.of(context)!.resetAllSettings,
                      AppLocalizations.of(context)!.resetToDefault,
                      Icons.restore,
                      () => _showResetDialog(context, settings),
                      isDestructive: true,
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Footer
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.footer,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: (newValue) async {
          await onChanged(newValue);
        },
      ),
    );
  }

  Widget _buildReminderTimeRangeTile(
    BuildContext context,
    String title,
    String subtitle,
    TimeOfDay startTime,
    TimeOfDay endTime,
    ValueChanged<TimeOfDay> onStartTimeChanged,
    ValueChanged<TimeOfDay> onEndTimeChanged,
  ) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: Text(
            '${startTime.format(context)} - ${endTime.format(context)}',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: _buildTimeButton(
                  context,
                  AppLocalizations.of(context)!.startTime,
                  startTime,
                  onStartTimeChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimeButton(
                  context,
                  AppLocalizations.of(context)!.endTime,
                  endTime,
                  onEndTimeChanged,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTimeButton(
    BuildContext context,
    String label,
    TimeOfDay time,
    ValueChanged<TimeOfDay> onChanged,
  ) {
    return OutlinedButton(
      onPressed: () async {
        final newTime = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (newTime != null) {
          onChanged(newTime);
        }
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: AppTheme.primaryColor),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time.format(context),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderIntervalTile(
    BuildContext context,
    String title,
    String subtitle,
    int intervalMinutes,
    ValueChanged<int> onIntervalMinutesChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton<int>(
        value: intervalMinutes,
        dropdownColor: AppTheme.surfaceColor,
        items: [
          DropdownMenuItem(value: 15, child: Text(AppLocalizations.of(context)!.every15Minutes)),
          DropdownMenuItem(value: 30, child: Text(AppLocalizations.of(context)!.every30Minutes)),
          DropdownMenuItem(value: 60, child: Text(AppLocalizations.of(context)!.every1Hour)),
          DropdownMenuItem(value: 120, child: Text(AppLocalizations.of(context)!.every2Hours)),
          DropdownMenuItem(value: 180, child: Text(AppLocalizations.of(context)!.every3Hours)),
          DropdownMenuItem(value: 240, child: Text(AppLocalizations.of(context)!.every4Hours)),
        ],
        onChanged: (newValue) {
          if (newValue != null) {
            onIntervalMinutesChanged(newValue);
          }
        },
        underline: Container(),
      ),
    );
  }

  Widget _buildDropdownTile<T>(
    BuildContext context,
    String title,
    String subtitle,
    T value,
    Map<T, String> options,
    ValueChanged<T> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton<T>(
        value: value,
        dropdownColor: AppTheme.surfaceColor,
        items: options.entries.map((entry) {
          return DropdownMenuItem<T>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        underline: Container(),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : AppTheme.primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(
        Icons.chevron_right,
        color: isDestructive ? Colors.red : AppTheme.textSecondaryColor,
      ),
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.aboutNeverr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.aboutDialogVersion),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.aboutDialogDescription),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.aboutDialogInspiration),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, AppSettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.resetSettings),
        content: Text(AppLocalizations.of(context)!.resetConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              await settings.resetSettings();
              
              // 重新加载习惯数据
              if (context.mounted) {
                final habitProvider = Provider.of<HabitProvider>(context, listen: false);
                await habitProvider.loadHabits();
              }
              
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.settingsReset)),
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.confirm),
          ),
        ],
      ),
    );
  }
}