import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Consumer<AppSettingsProvider>(
          builder: (context, settings, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notifications section
                _buildSection(
                  context,
                  '通知设置',
                  [
                    _buildSwitchTile(
                      context,
                      '启用通知',
                      '接收每日提醒通知',
                      settings.notificationsEnabled,
                      (value) => settings.updateNotificationsEnabled(value),
                    ),
                    if (settings.notificationsEnabled) ...[
                      _buildReminderTimeRangeTile(
                        context,
                        '提醒时间区间',
                        '设置提醒的开始和结束时间',
                        settings.reminderStartTime,
                        settings.reminderEndTime,
                        (startTime) => settings.updateReminderStartTime(startTime),
                        (endTime) => settings.updateReminderEndTime(endTime),
                      ),
                      _buildReminderIntervalTile(
                        context,
                        '提醒间隔',
                        '设置提醒的频率',
                        settings.reminderIntervalMinutes,
                        (intervalMinutes) => settings.updateReminderIntervalMinutes(intervalMinutes),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Theme section
                _buildSection(
                  context,
                  '外观设置',
                  [
                    _buildDropdownTile(
                      context,
                      '主题模式',
                      '选择应用主题',
                      settings.themeMode,
                      {
                        ThemeMode.system: '跟随系统',
                        ThemeMode.light: '浅色模式',
                        ThemeMode.dark: '深色模式',
                      },
                      (value) => settings.updateThemeMode(value),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Language section
                _buildSection(
                  context,
                  '语言设置',
                  [
                    _buildDropdownTile(
                      context,
                      '语言',
                      '选择应用语言',
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
                  '关于',
                  [
                    _buildActionTile(
                      context,
                      '关于 Neverr',
                      'Not just quitting. Becoming better.',
                      Icons.info_outline,
                      () => _showAboutDialog(context),
                    ),
                    _buildActionTile(
                      context,
                      '版本信息',
                      'v1.0.0',
                      Icons.smartphone,
                      () {},
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Danger zone
                _buildSection(
                  context,
                  '危险操作',
                  [
                    _buildActionTile(
                      context,
                      '重置所有设置',
                      '恢复到默认设置',
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
                    '© 2024 Neverr App\nMade with ❤️ for better habits',
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
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
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
                  '开始时间',
                  startTime,
                  onStartTimeChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimeButton(
                  context,
                  '结束时间',
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
          DropdownMenuItem(value: 15, child: const Text('每15分钟')),
          DropdownMenuItem(value: 30, child: const Text('每30分钟')),
          DropdownMenuItem(value: 60, child: const Text('每1小时')),
          DropdownMenuItem(value: 120, child: const Text('每2小时')),
          DropdownMenuItem(value: 180, child: const Text('每3小时')),
          DropdownMenuItem(value: 240, child: const Text('每4小时')),
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
        title: const Text('关于 Neverr'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('版本: v1.0.0'),
            SizedBox(height: 8),
            Text('Neverr 是一款帮助你改变习惯的应用，通过录制和重复播放自己的声音来重塑潜意识。'),
            SizedBox(height: 16),
            Text('灵感来源于关于潜意识和习惯改变的研究。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, AppSettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置设置'),
        content: const Text('确定要重置所有设置吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              settings.resetSettings();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('设置已重置')),
              );
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}