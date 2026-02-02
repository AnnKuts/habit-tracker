import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';

class HabitLocalStorage {
  final Box _box = Hive.box('habits_box');
  static const String _habitsKey = 'CURRENT_HABIT_LIST';

  ///myBox.get(yyyyMMdd) - habit list for a specific day
  ///myBox.get('START_DATE') - (first day of tracking)
  ///myBox.get('CURRENT_HABIT_LIST') - latest habit list
  ///myBox.get('PERCENTAGE_SUMMARY_yyyyMMdd')

  List<Habit> getHabits() {
    var raw = _box.get(_habitsKey);
    raw ??= _initDefaults();
    return (raw as List).map((item) => Habit.fromList(item)).toList();
  }

  void saveHabits(List<Habit> habits) {
    final data = habits.map((h) => h.toList()).toList();
    _box.put(_habitsKey, data);
  }

  List<Habit> _createDefaultHabits() {
    return [
      Habit(name: 'Morning run'),
      Habit(name: 'Read a book'),
      Habit(name: 'Meditation'),
      Habit(name: 'Practice coding'),
    ];
  }

  List<List<dynamic>> _initDefaults() {
    final defaults = _createDefaultHabits();
    final data = defaults.map((h) => h.toList()).toList();
    _box.put(_habitsKey, data);
    return data;
  }
}
