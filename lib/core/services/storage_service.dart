import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import '../../models/habit_item.dart';

class StorageService {
  static Database? _database;
  static const String _tableName = 'habits';

  static Future<void> initialize() async {
    _database = await _initDatabase();
  }

  static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'neverr.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            statement TEXT NOT NULL,
            emotionTag TEXT,
            audioPath TEXT,
            createdAt TEXT NOT NULL,
            completedDates TEXT NOT NULL,
            isActive INTEGER NOT NULL DEFAULT 1,
            todayRepeatCount INTEGER NOT NULL DEFAULT 0,
            dailyRepeatCounts TEXT NOT NULL DEFAULT '{}'
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE $_tableName ADD COLUMN todayRepeatCount INTEGER NOT NULL DEFAULT 0');
          await db.execute('ALTER TABLE $_tableName ADD COLUMN dailyRepeatCounts TEXT NOT NULL DEFAULT \'{}\'');
        }
      },
    );
  }

  static Database get database {
    if (_database == null) {
      throw Exception('Database not initialized. Call initialize() first.');
    }
    return _database!;
  }

  static Future<List<HabitItem>> getAllHabits() async {
    final List<Map<String, dynamic>> maps = await database.query(
      _tableName,
      where: 'isActive = ?',
      whereArgs: [1],
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      final map = Map<String, dynamic>.from(maps[i]);
      // Parse completedDates from JSON string
      final completedDatesString = map['completedDates'] as String;
      final List<String> dateStrings = completedDatesString.isEmpty 
          ? [] 
          : completedDatesString.split(',');
      map['completedDates'] = dateStrings;
      
      // Parse dailyRepeatCounts from JSON string
      final dailyRepeatCountsString = map['dailyRepeatCounts'] as String? ?? '{}';
      try {
        map['dailyRepeatCounts'] = json.decode(dailyRepeatCountsString);
      } catch (e) {
        map['dailyRepeatCounts'] = <String, int>{};
      }
      
      return HabitItem.fromMap(map);
    });
  }

  static Future<HabitItem?> getHabitById(String id) async {
    final List<Map<String, dynamic>> maps = await database.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final map = Map<String, dynamic>.from(maps.first);
      // Parse completedDates from JSON string
      final completedDatesString = map['completedDates'] as String;
      final List<String> dateStrings = completedDatesString.isEmpty 
          ? [] 
          : completedDatesString.split(',');
      map['completedDates'] = dateStrings;
      
      // Parse dailyRepeatCounts from JSON string
      final dailyRepeatCountsString = map['dailyRepeatCounts'] as String? ?? '{}';
      try {
        map['dailyRepeatCounts'] = json.decode(dailyRepeatCountsString);
      } catch (e) {
        map['dailyRepeatCounts'] = <String, int>{};
      }
      
      return HabitItem.fromMap(map);
    }
    return null;
  }

  static Future<void> insertHabit(HabitItem habit) async {
    final map = habit.toMap();
    // Convert completedDates to JSON string
    final completedDatesString = (map['completedDates'] as List<String>).join(',');
    map['completedDates'] = completedDatesString;
    
    // Convert dailyRepeatCounts to JSON string
    map['dailyRepeatCounts'] = json.encode(map['dailyRepeatCounts']);
    
    await database.insert(_tableName, map);
  }

  static Future<void> updateHabit(HabitItem habit) async {
    final map = habit.toMap();
    // Convert completedDates to JSON string
    final completedDatesString = (map['completedDates'] as List<String>).join(',');
    map['completedDates'] = completedDatesString;
    
    // Convert dailyRepeatCounts to JSON string
    map['dailyRepeatCounts'] = json.encode(map['dailyRepeatCounts']);
    
    await database.update(
      _tableName,
      map,
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  static Future<void> deleteHabit(String id) async {
    await database.update(
      _tableName,
      {'isActive': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> addCompletedDate(String habitId, DateTime date) async {
    final habit = await getHabitById(habitId);
    if (habit != null) {
      final completedDates = List<DateTime>.from(habit.completedDates);
      
      // Check if date is already in the list
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final isAlreadyCompleted = completedDates.any((d) => 
        d.year == normalizedDate.year && 
        d.month == normalizedDate.month && 
        d.day == normalizedDate.day
      );
      
      if (!isAlreadyCompleted) {
        completedDates.add(normalizedDate);
        final updatedHabit = habit.copyWith(completedDates: completedDates);
        await updateHabit(updatedHabit);
      }
    }
  }

  static Future<void> removeCompletedDate(String habitId, DateTime date) async {
    final habit = await getHabitById(habitId);
    if (habit != null) {
      final completedDates = List<DateTime>.from(habit.completedDates);
      
      completedDates.removeWhere((d) => 
        d.year == date.year && 
        d.month == date.month && 
        d.day == date.day
      );
      
      final updatedHabit = habit.copyWith(completedDates: completedDates);
      await updateHabit(updatedHabit);
    }
  }

  static Future<void> resetTodayRepeatCounts() async {
    await database.update(
      _tableName,
      {'todayRepeatCount': 0},
      where: 'isActive = ?',
      whereArgs: [1],
    );
  }

  static Future<void> clearAllData() async {
    await database.delete(_tableName);
  }
}