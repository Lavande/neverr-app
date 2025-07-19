import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class StatsCard extends StatelessWidget {
  final int completedToday;
  final int totalHabits;
  final double completionRate;
  final int todayRepeatCount;

  const StatsCard({
    super.key,
    required this.completedToday,
    required this.totalHabits,
    required this.completionRate,
    required this.todayRepeatCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '今日进度',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCompletionColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getCompletionText(),
                    style: TextStyle(
                      color: _getCompletionColor(),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Progress circle
            Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Progress circle
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: completionRate,
                          strokeWidth: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getCompletionColor(),
                          ),
                        ),
                      ),
                      
                      // Center text
                      Text(
                        '${(completionRate * 100).round()}%',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 24),
                
                // Stats
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatItem(
                        '已完成',
                        '$completedToday',
                        AppTheme.successColor,
                        Icons.check_circle,
                      ),
                      const SizedBox(height: 8),
                      _buildStatItem(
                        '重复次数',
                        '$todayRepeatCount',
                        AppTheme.primaryColor,
                        Icons.refresh,
                      ),
                      const SizedBox(height: 8),
                      _buildStatItem(
                        '未完成',
                        '${totalHabits - completedToday}',
                        Colors.grey.shade500,
                        Icons.radio_button_unchecked,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Motivational message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getMotivationalMessage(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 16,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Color _getCompletionColor() {
    if (completionRate >= 1.0) {
      return AppTheme.successColor;
    } else if (completionRate >= 0.5) {
      return AppTheme.primaryColor;
    } else {
      return AppTheme.warningColor;
    }
  }

  String _getCompletionText() {
    if (completionRate >= 1.0) {
      return '完美';
    } else if (completionRate >= 0.8) {
      return '优秀';
    } else if (completionRate >= 0.5) {
      return '良好';
    } else {
      return '加油';
    }
  }

  String _getMotivationalMessage() {
    if (completionRate >= 1.0) {
      return '🎉 今天表现完美！继续保持这个节奏！';
    } else if (completionRate >= 0.8) {
      return '👏 做得很好！再努力一点就能达到完美！';
    } else if (completionRate >= 0.5) {
      return '💪 不错的开始！继续加油完成剩余任务！';
    } else if (totalHabits > 0) {
      return '🌟 每一步都是进步！现在开始也不晚！';
    } else {
      return '🚀 创建你的第一个习惯，开始改变之旅！';
    }
  }
}