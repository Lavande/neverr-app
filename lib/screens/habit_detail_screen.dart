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

class _HabitDetailScreenState extends State<HabitDetailScreen>
    with TickerProviderStateMixin {
  final TextEditingController _statementController = TextEditingController();
  bool _isEditing = false;
  bool _isPlaying = false;
  DateTime _selectedDay = DateTime.now();
  int _loopCount = 1;
  int _currentLoop = 0;
  bool _isLoopPlaying = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _statementController.text = widget.habit.statement;
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _statementController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _onSelfReading() async {
    // 触发脉冲动画
    _pulseController.forward().then((_) => _pulseController.reverse());
    
    // 增加重复次数
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final currentHabit = habitProvider.getHabitById(widget.habit.id) ?? widget.habit;
    
    try {
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final newDailyRepeatCounts = Map<String, int>.from(currentHabit.dailyRepeatCounts);
      newDailyRepeatCounts[dateKey] = (newDailyRepeatCounts[dateKey] ?? 0) + 1;
      
      // 如果是今天的第一次重复，添加到完成日期
      final newCompletedDates = List<DateTime>.from(currentHabit.completedDates);
      final todayNormalized = DateTime(today.year, today.month, today.day);
      final isAlreadyCompleted = newCompletedDates.any((date) => 
        date.year == todayNormalized.year && 
        date.month == todayNormalized.month && 
        date.day == todayNormalized.day
      );
      if (!isAlreadyCompleted && currentHabit.todayRepeatCount == 0) {
        newCompletedDates.add(todayNormalized);
      }
      
      final updatedHabit = currentHabit.copyWith(
        todayRepeatCount: currentHabit.todayRepeatCount + 1,
        dailyRepeatCounts: newDailyRepeatCounts,
        completedDates: newCompletedDates,
      );
      await habitProvider.updateHabit(updatedHabit);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('很棒！已记录第 ${updatedHabit.todayRepeatCount} 次朗读'),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('记录失败: $e')),
        );
      }
    }
  }

  Future<void> _playAudio() async {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final currentHabit = habitProvider.getHabitById(widget.habit.id) ?? widget.habit;
    
    if (currentHabit.audioPath != null) {
      setState(() {
        _isPlaying = true;
      });
      
      try {
        await AudioService.playRecording(currentHabit.audioPath!);
        await Future.delayed(const Duration(seconds: 5));
        
        // 播放完成后增加重复次数
        await _incrementRepeatCount();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('播放失败: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      }
    }
  }

  Future<void> _playAudioLoop() async {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final currentHabit = habitProvider.getHabitById(widget.habit.id) ?? widget.habit;
    
    if (currentHabit.audioPath == null) return;
    
    setState(() {
      _isLoopPlaying = true;
      _currentLoop = 0;
    });
    
    try {
      for (int i = 0; i < _loopCount; i++) {
        if (!_isLoopPlaying) break;
        
        setState(() {
          _currentLoop = i + 1;
        });
        
        await AudioService.playRecording(currentHabit.audioPath!);
        await Future.delayed(const Duration(seconds: 5));
        
        if (_isLoopPlaying) {
          await _incrementRepeatCount();
        }
        
        // 循环间隔
        if (i < _loopCount - 1 && _isLoopPlaying) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('播放失败: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoopPlaying = false;
          _currentLoop = 0;
        });
      }
    }
  }

  Future<void> _stopLoop() async {
    setState(() {
      _isLoopPlaying = false;
    });
    await AudioService.stopPlaying();
  }

  Future<void> _incrementRepeatCount() async {
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    final currentHabit = habitProvider.getHabitById(widget.habit.id) ?? widget.habit;
    
    try {
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final newDailyRepeatCounts = Map<String, int>.from(currentHabit.dailyRepeatCounts);
      newDailyRepeatCounts[dateKey] = (newDailyRepeatCounts[dateKey] ?? 0) + 1;
      
      // 如果是今天的第一次重复，添加到完成日期
      final newCompletedDates = List<DateTime>.from(currentHabit.completedDates);
      final todayNormalized = DateTime(today.year, today.month, today.day);
      final isAlreadyCompleted = newCompletedDates.any((date) => 
        date.year == todayNormalized.year && 
        date.month == todayNormalized.month && 
        date.day == todayNormalized.day
      );
      if (!isAlreadyCompleted && currentHabit.todayRepeatCount == 0) {
        newCompletedDates.add(todayNormalized);
      }
      
      final updatedHabit = currentHabit.copyWith(
        todayRepeatCount: currentHabit.todayRepeatCount + 1,
        dailyRepeatCounts: newDailyRepeatCounts,
        completedDates: newCompletedDates,
      );
      await habitProvider.updateHabit(updatedHabit);
    } catch (e) {
      // 静默处理错误，不影响播放体验
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
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        // Get the latest habit data from provider
        final currentHabit = habitProvider.getHabitById(widget.habit.id) ?? widget.habit;
        
        return Scaffold(
          backgroundColor: AppTheme.backgroundColor,
          appBar: AppBar(
            title: Text(currentHabit.title),
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
                        currentHabit.statement,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textPrimaryColor,
                          height: 1.5,
                        ),
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Reading options
                    Text(
                      '练习方式',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Self reading option (recommended)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.mic,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '自己朗读（推荐）',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '对着句子自己朗读，每读一次点击按钮记录',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: ElevatedButton.icon(
                                    onPressed: _onSelfReading,
                                    icon: const Icon(Icons.add_circle),
                                    label: const Text('我读了一遍'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Audio playback option
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.headphones,
                                color: Colors.grey.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '播放录音（适合公共场合）',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '播放之前录制的语音，可选择循环次数',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Loop count selector
                          Row(
                            children: [
                              Text(
                                '循环次数:',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(width: 8),
                              ...List.generate(3, (index) {
                                final count = [1, 5, 10][index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text('${count}次'),
                                    selected: _loopCount == count,
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(() {
                                          _loopCount = count;
                                        });
                                      }
                                    },
                                    selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                                    labelStyle: TextStyle(
                                      color: _loopCount == count 
                                          ? AppTheme.primaryColor 
                                          : Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Play controls
                          if (currentHabit.audioPath != null)
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _isLoopPlaying ? null : (_isPlaying ? null : _playAudio),
                                    icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                                    label: Text(_isPlaying ? '播放中...' : '播放一次'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade600,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _isPlaying ? null : (_isLoopPlaying ? _stopLoop : _playAudioLoop),
                                    icon: Icon(_isLoopPlaying ? Icons.stop : Icons.repeat),
                                    label: Text(_isLoopPlaying 
                                        ? '停止 (${_currentLoop}/${_loopCount})'
                                        : '循环播放'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _isLoopPlaying 
                                          ? AppTheme.warningColor 
                                          : AppTheme.secondaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              '暂无录音文件',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
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
                          '${currentHabit.currentStreak}天',
                          AppTheme.successColor,
                          Icons.local_fire_department,
                        ),
                        _buildStatItem(
                          '总完成',
                          '${currentHabit.completedDates.length}天',
                          AppTheme.primaryColor,
                          Icons.check_circle,
                        ),
                        _buildStatItem(
                          '今日重复',
                          '${currentHabit.todayRepeatCount}次',
                          AppTheme.secondaryColor,
                          Icons.refresh,
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
                      firstDay: currentHabit.createdAt,
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _selectedDay,
                      calendarFormat: CalendarFormat.month,
                      eventLoader: (day) {
                        final repeatCount = currentHabit.getRepeatCountForDate(day);
                        // 如果有重复次数，返回该日期作为事件
                        return repeatCount > 0 ? [day] : [];
                      },
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final repeatCount = currentHabit.getRepeatCountForDate(day);
                          if (repeatCount > 0) {
                            return Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  _buildRepeatCountMarker(repeatCount),
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
                          final repeatCount = currentHabit.getRepeatCountForDate(day);
                          return Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (repeatCount > 0) _buildRepeatCountMarker(repeatCount),
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
                      ),
                      calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                        weekendTextStyle: TextStyle(color: AppTheme.textPrimaryColor),
                        holidayTextStyle: TextStyle(color: AppTheme.textPrimaryColor),
                        // 移除默认的 markerDecoration，使用自定义的 builder
                        markersMaxCount: 0, // 禁用默认标记点
                        markerDecoration: BoxDecoration(), // 清空默认标记装饰
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
      },
    );
  }

  Widget _buildRepeatCountMarker(int repeatCount) {
    // 根据重复次数计算颜色深度，增加透明度以便看清数字
    double opacity;
    if (repeatCount == 1) {
      opacity = 0.15;
    } else if (repeatCount == 2) {
      opacity = 0.25;
    } else if (repeatCount <= 5) {
      opacity = 0.35;
    } else if (repeatCount <= 10) {
      opacity = 0.45;
    } else {
      opacity = 0.55;
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