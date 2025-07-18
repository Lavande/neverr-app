import 'package:uuid/uuid.dart';

class HabitItem {
  final String id;
  final String title;
  final String statement;
  final String? emotionTag;
  final String? audioPath;
  final DateTime createdAt;
  final List<DateTime> completedDates;
  final bool isActive;

  HabitItem({
    String? id,
    required this.title,
    required this.statement,
    this.emotionTag,
    this.audioPath,
    DateTime? createdAt,
    List<DateTime>? completedDates,
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        completedDates = completedDates ?? [];

  HabitItem copyWith({
    String? id,
    String? title,
    String? statement,
    String? emotionTag,
    String? audioPath,
    DateTime? createdAt,
    List<DateTime>? completedDates,
    bool? isActive,
  }) {
    return HabitItem(
      id: id ?? this.id,
      title: title ?? this.title,
      statement: statement ?? this.statement,
      emotionTag: emotionTag ?? this.emotionTag,
      audioPath: audioPath ?? this.audioPath,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'statement': statement,
      'emotionTag': emotionTag,
      'audioPath': audioPath,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates.map((date) => date.toIso8601String()).toList(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory HabitItem.fromMap(Map<String, dynamic> map) {
    return HabitItem(
      id: map['id'],
      title: map['title'],
      statement: map['statement'],
      emotionTag: map['emotionTag'],
      audioPath: map['audioPath'],
      createdAt: DateTime.parse(map['createdAt']),
      completedDates: (map['completedDates'] as List<dynamic>?)
          ?.map((date) => DateTime.parse(date))
          .toList() ?? [],
      isActive: map['isActive'] == 1,
    );
  }

  bool get isCompletedToday {
    final today = DateTime.now();
    return completedDates.any((date) => 
      date.year == today.year && 
      date.month == today.month && 
      date.day == today.day
    );
  }

  int get currentStreak {
    if (completedDates.isEmpty) return 0;
    
    final sortedDates = completedDates.map((date) => 
      DateTime(date.year, date.month, date.day)
    ).toSet().toList()..sort((a, b) => b.compareTo(a));
    
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    
    int streak = 0;
    DateTime checkDate = todayNormalized;
    
    for (final date in sortedDates) {
      if (date.isAtSameMomentAs(checkDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (date.isBefore(checkDate)) {
        if (checkDate.difference(date).inDays == 1) {
          streak++;
          checkDate = date.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }
    }
    
    return streak;
  }

  double get completionRate {
    if (completedDates.isEmpty) return 0.0;
    
    final daysSinceCreation = DateTime.now().difference(createdAt).inDays + 1;
    return (completedDates.length / daysSinceCreation).clamp(0.0, 1.0);
  }

  @override
  String toString() {
    return 'HabitItem(id: $id, title: $title, statement: $statement, completedDates: ${completedDates.length})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}