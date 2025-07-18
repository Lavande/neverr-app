import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../core/theme/app_theme.dart';
import '../core/services/audio_service.dart';
import '../models/habit_item.dart';
import '../providers/habit_provider.dart';

class HabitDetailScreen extends StatefulWidget {
  final HabitItem habit;

  const HabitDetailScreen({
    super.key,
    required this.habit,
  });

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  final TextEditingController _statementController = TextEditingController();
  bool _isEditing = false;
  bool _isPlaying = false;
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _statementController.text = widget.habit.statement;
  }

  @override
  void dispose() {
    _statementController.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if (widget.habit.audioPath != null) {
      setState(() {
        _isPlaying = true;
      });
      
      try {
        await AudioService.playRecording(widget.habit.audioPath!);
        await Future.delayed(const Duration(seconds: 5));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('播放失败: $e')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      }
    }
  }

  Future<void> _saveChanges() async {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    
    try {
      final updatedHabit = widget.habit.copyWith(
        statement: _statementController.text.trim(),
      );
      
      await habitProvider.updateHabit(updatedHabit);
      
      setState(() {
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('保存成功')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败: $e')),
      );
    }
  }

  Future<void> _deleteHabit() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除确认'),
        content: const Text('确定要删除这个习惯吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    
    if (result == true) {
      try {
        final habitProvider = Provider.of<HabitProvider>(context, listen: false);
        await habitProvider.deleteHabit(widget.habit.id);
        
        if (mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('删除失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(widget.habit.title),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: _saveChanges,
              child: const Text('保存'),
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _deleteHabit();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('删除'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statement section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '语句内容',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    if (_isEditing)
                      TextField(
                        controller: _statementController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '输入你的语句...',
                        ),
                        maxLines: 3,
                      )
                    else
                      Text(
                        widget.habit.statement,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textPrimaryColor,
                          height: 1.5,
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Play button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _playAudio,
                        icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                        label: Text(_isPlaying ? '停止播放' : '播放语音'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Stats section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '统计数据',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          '当前连续',
                          '${widget.habit.currentStreak}天',
                          AppTheme.successColor,
                          Icons.local_fire_department,
                        ),
                        _buildStatItem(
                          '总完成',
                          '${widget.habit.completedDates.length}天',
                          AppTheme.primaryColor,
                          Icons.check_circle,
                        ),
                        _buildStatItem(
                          '完成率',
                          '${(widget.habit.completionRate * 100).round()}%',
                          AppTheme.secondaryColor,
                          Icons.trending_up,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Calendar section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '打卡日历',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TableCalendar<DateTime>(
                      firstDay: widget.habit.createdAt,
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _selectedDay,
                      calendarFormat: CalendarFormat.month,
                      eventLoader: (day) {
                        return widget.habit.completedDates.where((date) =>
                          date.year == day.year &&
                          date.month == day.month &&
                          date.day == day.day,
                        ).toList();
                      },
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        weekendTextStyle: TextStyle(color: AppTheme.textPrimaryColor),
                        holidayTextStyle: TextStyle(color: AppTheme.textPrimaryColor),
                        markerDecoration: BoxDecoration(
                          color: AppTheme.successColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
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
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}