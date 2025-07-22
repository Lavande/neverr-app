import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../core/theme/app_theme.dart';
import '../providers/habit_provider.dart';
import '../widgets/stats_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dataStatistics),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats Card
                StatsCard(
                  completedToday: habitProvider.completedTodayHabits.length,
                  totalHabits: habitProvider.totalActiveHabits,
                  completionRate: habitProvider.todayCompletionRate,
                  todayRepeatCount: habitProvider.todayTotalRepeatCount,
                ),
                
                const SizedBox(height: 24),
                
                // Calendar section
                Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.checkInCalendar,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.dailyRepeatCount,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification notification) {
                            // 让滚动通知继续向上传播
                            return false;
                          },
                          child: TableCalendar<DateTime>(
                          firstDay: habitProvider.earliestHabitDate ?? DateTime.now().subtract(const Duration(days: 365)),
                          lastDay: DateTime.now().add(const Duration(days: 365)),
                          focusedDay: _focusedDay,
                          calendarFormat: CalendarFormat.month,
                          pageAnimationEnabled: false,
                          sixWeekMonthsEnforced: true,
                          availableGestures: AvailableGestures.horizontalSwipe,
                          eventLoader: (day) {
                            final totalRepeatCount = habitProvider.getTotalRepeatCountForDate(day);
                            return totalRepeatCount > 0 ? [day] : [];
                          },
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              final totalRepeatCount = habitProvider.getTotalRepeatCountForDate(day);
                              if (totalRepeatCount > 0) {
                                return Container(
                                  margin: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      _buildRepeatCountMarker(totalRepeatCount),
                                      Text(
                                        '${day.day}',
                                        style: TextStyle(
                                          color: AppTheme.textPrimaryColor,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return null;
                            },
                            todayBuilder: (context, day, focusedDay) {
                              final totalRepeatCount = habitProvider.getTotalRepeatCountForDate(day);
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                alignment: Alignment.center,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (totalRepeatCount > 0) _buildRepeatCountMarker(totalRepeatCount),
                                    Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            selectedBuilder: (context, day, focusedDay) {
                              final totalRepeatCount = habitProvider.getTotalRepeatCountForDate(day);
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (totalRepeatCount > 0) _buildRepeatCountMarker(totalRepeatCount),
                                    Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          calendarStyle: CalendarStyle(
                            outsideDaysVisible: false,
                            weekendTextStyle: TextStyle(color: AppTheme.textPrimaryColor),
                            holidayTextStyle: TextStyle(color: AppTheme.textPrimaryColor),
                            markersMaxCount: 0, // 禁用默认标记点
                            markerDecoration: BoxDecoration(), // 清空默认标记装饰
                          ),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            leftChevronVisible: true,
                            rightChevronVisible: true,
                            leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: AppTheme.primaryColor,
                            ),
                            rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          onHeaderTapped: (focusedDay) {
                            // 可以在这里处理标题点击事件
                          },
                          onCalendarCreated: (controller) {
                            // 保存控制器引用以便手动控制
                          },
                        ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Selected day details
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.dateFormat(_selectedDay.year, _selectedDay.month, _selectedDay.day),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildDayDetails(habitProvider, _selectedDay),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRepeatCountMarker(int repeatCount) {
    double opacity;
    if (repeatCount == 1) {
      opacity = 0.15;
    } else if (repeatCount == 2) {
      opacity = 0.25;
    } else if (repeatCount <= 5) {
      opacity = 0.35;
    } else if (repeatCount <= 10) {
      opacity = 0.45;
    } else if (repeatCount <= 20) {
      opacity = 0.55;
    } else {
      opacity = 0.65;
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppTheme.successColor.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDayDetails(HabitProvider habitProvider, DateTime selectedDay) {
    final totalRepeatCount = habitProvider.getTotalRepeatCountForDate(selectedDay);
    final habitDetails = habitProvider.getHabitDetailsForDate(selectedDay);
    
    if (totalRepeatCount == 0) {
      return Text(
        AppLocalizations.of(context)!.noRecordsForDate,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppTheme.textSecondaryColor,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.totalRepeats(totalRepeatCount),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        for (final entry in habitDetails.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(
                  Icons.circle,
                  size: 6,
                  color: AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.habitRepeats(entry.key, entry.value),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// 自定义手势识别器，允许多个手势同时工作
class AllowMultipleGestureRecognizer extends PanGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    // 不拒绝手势，允许多个手势识别器同时工作
    acceptGesture(pointer);
  }
}