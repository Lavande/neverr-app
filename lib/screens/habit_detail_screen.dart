import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/services/audio_service.dart';
import '../models/habit_item.dart';
import '../providers/habit_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  int _loopCount = 5;
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
            content: Text(AppLocalizations.of(context)!.recordingSuccess(updatedHabit.todayRepeatCount)),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.playFailed(e.toString()))),
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
            SnackBar(content: Text(AppLocalizations.of(context)!.playFailed(e.toString()))),
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
        SnackBar(content: Text(AppLocalizations.of(context)!.playFailed(e.toString()))),
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
        SnackBar(content: Text(AppLocalizations.of(context)!.saveSuccess)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.saveFailed(e.toString()))),
      );
    }
  }

  Future<void> _deleteHabit() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteConfirmTitle),
        content: Text(AppLocalizations.of(context)!.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.delete),
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
          SnackBar(content: Text(AppLocalizations.of(context)!.deleteFailed(e.toString()))),
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
              child: Text(AppLocalizations.of(context)!.save),
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
              PopupMenuItem(
                value: 'delete',
                child: Text(AppLocalizations.of(context)!.delete),
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
                      AppLocalizations.of(context)!.selfTalk,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    if (_isEditing)
                      TextField(
                        controller: _statementController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: AppLocalizations.of(context)!.enterStatement,
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
                      AppLocalizations.of(context)!.practiceMethod,
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
                                AppLocalizations.of(context)!.selfReadingRecommended,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.selfReadingDescription,
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
                                    label: Text(AppLocalizations.of(context)!.iReadOnce),
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
                                AppLocalizations.of(context)!.audioPlayback,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(context)!.audioPlaybackDescription,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Loop count selector
                          Row(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.loopCountLabel,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(width: 8),
                              ...List.generate(3, (index) {
                                final count = [5, 10, 15][index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ChoiceChip(
                                    label: Text('$count${AppLocalizations.of(context)!.loopTimesUnit}'),
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
                                    label: Text(_isPlaying ? AppLocalizations.of(context)!.playing : AppLocalizations.of(context)!.playOnce),
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
                                        ? AppLocalizations.of(context)!.stopLoop(_currentLoop, _loopCount)
                                        : AppLocalizations.of(context)!.loopPlay),
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
                              AppLocalizations.of(context)!.noRecordingFile,
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
                      AppLocalizations.of(context)!.statisticsData,
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
                          AppLocalizations.of(context)!.currentStreakLabel,
                          '${currentHabit.currentStreak}${AppLocalizations.of(context)!.daysUnit}',
                          AppTheme.successColor,
                          Icons.local_fire_department,
                        ),
                        _buildStatItem(
                          AppLocalizations.of(context)!.totalCompletedLabel,
                          '${currentHabit.completedDates.length}${AppLocalizations.of(context)!.daysUnit}',
                          AppTheme.primaryColor,
                          Icons.check_circle,
                        ),
                        _buildStatItem(
                          AppLocalizations.of(context)!.todayRepeatLabel,
                          '${currentHabit.todayRepeatCount}${AppLocalizations.of(context)!.timesUnit}',
                          AppTheme.secondaryColor,
                          Icons.refresh,
                        ),
                      ],
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