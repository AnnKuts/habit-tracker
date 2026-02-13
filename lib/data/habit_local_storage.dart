import 'package:habit_tracker/utils/time_converter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';

class HabitLocalStorage {
  final Box _box = Hive.box('habits_box');
  static const String _habitsKey = 'CURRENT_HABIT_LIST';
  static const String _startDateKey = 'START_DATE';
  Map<DateTime, int> heatMapDataSet = {};

  ///myBox.get(yyyyMMdd) - habit list for a specific day
  ///myBox.get('START_DATE') - (first day of tracking)
  ///myBox.get('CURRENT_HABIT_LIST') - latest habit list
  ///myBox.get('PERCENTAGE_SUMMARY_yyyyMMdd')

  List<Habit> getHabits() {
    var raw = _box.get(_habitsKey);
    raw ??= _initDefaults();
    return (raw as List).map((item) => Habit.fromList(item)).toList();
  }

  Map<String, Habit> getHabitsAsMap() {
    final habitsList = getHabits();
    return {for (var habit in habitsList) habit.id: habit};
  }

  Habit? findHabitById(String id) {
    final habitsMap = getHabitsAsMap();
    return habitsMap[id];
  }

  void _checkForNewDay() {
    final String todayKey = todaysDateFormatted();
    if (!_box.containsKey(todayKey)) {
      final List<List<dynamic>> previousList =
          _box.get('CURRENT_HABIT_LIST') ?? [];
      _box.put(todayKey, previousList);
    }
  }

  void saveHabits(List<Habit> habits) {
    final data = habits.map((h) => h.toList()).toList();
    _box.put(_habitsKey, data);
  }

  String getStartDate() {
    return _box.get(_startDateKey) ?? _initStartDate();
  }

  String _initStartDate() {
    final now = DateTime.now();

    final formatted =
        '${now.year}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}';

    _box.put(_startDateKey, formatted);
    return formatted;
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

  void updateDatabase(List<List<dynamic>> todaysHabitList) {
    _box.put(todaysDateFormatted(), todaysHabitList);
    _box.put('CURRENT_HABIT_LIST', todaysHabitList);
    calculateHabitPercentage(todaysHabitList);
    loadHeatMap();
  }

  void calculateHabitPercentage(List<List<dynamic>> todaysHabitList) {
    int countCompleted = 0;

    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][2] == true) {
        countCompleted++;
      }
    }

    final percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    _box.put('PERCENTAGE_SUMMARY_${todaysDateFormatted()}', percent);
  }

  void loadHeatMap() {
    heatMapDataSet.clear();

    final DateTime startDate = createDataTimeObject(getStartDate());

    final int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i <= daysInBetween; i++) {
      final DateTime currentDate = startDate.add(Duration(days: i));
      final String dateKey = dateTimeToString(currentDate);

      final String percentString =
          _box.get('PERCENTAGE_SUMMARY_$dateKey') ?? '0.0';

      final double percent = double.parse(percentString);

      final DateTime normalizedDate = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
      );

      heatMapDataSet[normalizedDate] = (percent * 10).toInt();
    }
  }
}
