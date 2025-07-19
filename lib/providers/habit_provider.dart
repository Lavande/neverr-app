import 'package:flutter/foundation.dart';
import '../models/habit_item.dart';
import '../core/services/storage_service.dart';

class HabitProvider with ChangeNotifier {
  List<HabitItem> _habits = [];
  bool _isLoading = false;

  List<HabitItem> get habits => _habits;
  bool get isLoading => _isLoading;

  List<HabitItem> get activeHabits => _habits.where((habit) => habit.isActive).toList();

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      _habits = await StorageService.getAllHabits();
    } catch (e) {
      debugPrint('Error loading habits: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addHabit(HabitItem habit) async {
    try {
      await StorageService.insertHabit(habit);
      _habits.add(habit);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding habit: $e');
      rethrow;
    }
  }

  Future<void> updateHabit(HabitItem habit) async {
    try {
      await StorageService.updateHabit(habit);
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _habits[index] = habit;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating habit: $e');
      rethrow;
    }
  }

  Future<void> deleteHabit(String habitId) async {
    try {
      await StorageService.deleteHabit(habitId);
      _habits.removeWhere((habit) => habit.id == habitId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting habit: $e');
      rethrow;
    }
  }

  Future<void> markHabitCompleted(String habitId) async {
    try {
      await StorageService.addCompletedDate(habitId, DateTime.now());
      final habit = await StorageService.getHabitById(habitId);
      if (habit != null) {
        final index = _habits.indexWhere((h) => h.id == habitId);
        if (index != -1) {
          _habits[index] = habit;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error marking habit as completed: $e');
      rethrow;
    }
  }

  Future<void> markHabitUncompleted(String habitId) async {
    try {
      await StorageService.removeCompletedDate(habitId, DateTime.now());
      final habit = await StorageService.getHabitById(habitId);
      if (habit != null) {
        final index = _habits.indexWhere((h) => h.id == habitId);
        if (index != -1) {
          _habits[index] = habit;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error marking habit as uncompleted: $e');
      rethrow;
    }
  }

  Future<void> toggleHabitCompletion(String habitId) async {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    if (habit.isCompletedToday) {
      await markHabitUncompleted(habitId);
    } else {
      await markHabitCompleted(habitId);
    }
  }

  HabitItem? getHabitById(String id) {
    try {
      return _habits.firstWhere((habit) => habit.id == id);
    } catch (e) {
      return null;
    }
  }

  List<HabitItem> get completedTodayHabits {
    return _habits.where((habit) => habit.isCompletedToday).toList();
  }

  List<HabitItem> get pendingTodayHabits {
    return _habits.where((habit) => !habit.isCompletedToday).toList();
  }

  double get todayCompletionRate {
    if (_habits.isEmpty) return 0.0;
    return completedTodayHabits.length / _habits.length;
  }

  int get totalActiveHabits => activeHabits.length;

  int get todayTotalRepeatCount {
    return _habits.fold(0, (sum, habit) => sum + habit.todayRepeatCount);
  }

  Map<String, int> get weeklyStats {
    final Map<String, int> stats = {};
    final now = DateTime.now();
    
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final dayKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      int completedCount = 0;
      for (final habit in _habits) {
        final completed = habit.completedDates.any((d) => 
          d.year == date.year && d.month == date.month && d.day == date.day);
        if (completed) completedCount++;
      }
      
      stats[dayKey] = completedCount;
    }
    
    return stats;
  }

  Future<void> refreshHabits() async {
    await loadHabits();
  }
}