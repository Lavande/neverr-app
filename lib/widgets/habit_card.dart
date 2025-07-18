import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/services/audio_service.dart';
import '../models/habit_item.dart';

class HabitCard extends StatefulWidget {
  final HabitItem habit;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onToggleComplete,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  bool _isPlaying = false;

  Future<void> _playAudio() async {
    if (widget.habit.audioPath != null) {
      setState(() {
        _isPlaying = true;
      });
      
      try {
        await AudioService.playRecording(widget.habit.audioPath!);
        
        // Simulate audio duration for demo
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.habit.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ),
                  // Completion checkbox
                  GestureDetector(
                    onTap: widget.onToggleComplete,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: widget.habit.isCompletedToday
                            ? AppTheme.successColor
                            : Colors.transparent,
                        border: Border.all(
                          color: widget.habit.isCompletedToday
                              ? AppTheme.successColor
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: widget.habit.isCompletedToday
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Statement
              Text(
                widget.habit.statement,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 16),
              
              // Action row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Play button
                  GestureDetector(
                    onTap: _playAudio,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isPlaying ? Icons.stop : Icons.play_arrow,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isPlaying ? '播放中...' : '播放',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Streak indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.habit.currentStreak > 0
                          ? AppTheme.successColor.withOpacity(0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: widget.habit.currentStreak > 0
                              ? AppTheme.successColor
                              : Colors.grey.shade500,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.habit.currentStreak}',
                          style: TextStyle(
                            color: widget.habit.currentStreak > 0
                                ? AppTheme.successColor
                                : Colors.grey.shade500,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}